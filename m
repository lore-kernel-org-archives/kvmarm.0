Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5453BF68F;
	Thu, 15 Oct 2026 14:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075106; cv=none; b=k8jBpiuHwsFZQ2fAuRkAZknqSGy3v7/Ybolv9U2ORhFRejIF2FhmHLZStvBX93sZdFX/b/AD3lrXlI3V5CVgUtKhqGJ7FxzuTfbF5e5DY8qfY5RkA7KalO0MVZomKCVD5hcPNDRz8T7ixdqJlkhzu61h7J/dwp1PeqyqS2kc+zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075106; c=relaxed/simple;
	bh=3eicMzqvoduiS5w7ckxuXHXZgiiL8L5Gnx9fi08KClM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=buFqoNPuJFHX7aLwis/+1NN0JuHYKCQxVH1B+0Qbhc8l6LCSURM5Plct5apVgLBv3S0MFOkBU5tyMS2bBMLPFbzJ0USvi4XXc/iSdepNdYnJ/slknQIbjrk6NgVZZbQvgw0C2BhAzF9YVef/v9cvDHMSdqRxkvq8DMrEkeHmK3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpboLlr5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpboLlr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F1B1F000C4;
	Thu, 15 Oct 2026 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075105;
	bh=ue7wn5onuaDHQRN4z9B/8WHxbQ0QXbio4cv6N1Y06JA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YpboLlr5ABJRFMa/EeCSwk6XNAKW7bZgoOHDkEzOLnphexPS2bi/XZqY2q553Co+s
	 sxX4ibPADtl8YDPgKBveApiuniGcno2j82Q7laQ3zYzGTxGyzs3Ep39mpwmTob/3EO
	 dcdzuQiz6kWoNIb1F595zNTDaoDtbYK2gJn09Pd+U/HKBEwSly+aYkn/IXpr5h4MJM
	 mPlgMV/NUDxf2H9UQGPCZgvGnjKWCKw1KkbOa/0/ol9FfLcSN0R1K1VpOSshXbFEoB
	 ozAQkjr0E+pJTBASuVO+n8uO4CBJMmMkE8U/HBjtQUMcdmBv/8syv5FXk2DZALt4L/
	 b0byKjjBhnFgw==
Message-ID: <sashiko-outbox-172967@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 08/15] misc/arm-cla: Manage domain contexts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Roberts" <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, robh@kernel.org, conor+dt@kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015142552.4128028-9-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-9-ryan.roberts@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:38:22 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] kthread: missing format argument in kthread_run_worker_on_cpu
- [Medium] sched: timeslice starvation via kthread_mod_delayed_work
--

commit 9e218cd8677c5cff035aa302edfc44906aa6b821
Author: Ryan Roberts <ryan.roberts@arm.com>
misc/arm-cla: Manage domain contexts

This commit introduces a domain scheduler for the CLA driver that queues
contexts for assignment with a fixed time slice. It runs hardware operations
through CPU-bound kthread workers to coordinate per-device and domain
switching. Failures on any device mark the entire domain as broken and
wake all waiters.

> diff --git a/drivers/misc/arm-cla/cla-init.c b/drivers/misc/arm-cla/cla-i=
nit.c
> index 58f37787a59c1..e1694f84e05d0 100644
> --- a/drivers/misc/arm-cla/cla-init.c
> +++ b/drivers/misc/arm-cla/cla-init.c
[ ... ]
> @@ -198,6 +201,37 @@ static void cla_dev_reinit(struct cla_dev *dev)
>  	cla_reg_write(dev, CLA_REG_LRESP, 0);
>  }
> =20
> +static int cla_dev_worker_init(struct cla_dev *dev, int cpu)
> +{
> +	struct kthread_worker *worker;
> +
> +	worker =3D kthread_run_worker_on_cpu(cpu, 0, "cla-dev-worker/%u");

[Severity: Medium]
Is this missing a format argument for the %u specifier?

It looks like kthread_run_worker_on_cpu() is being called with the format
string "cla-dev-worker/%u", but without a corresponding unsigned int
argument. Will vsnprintf read uninitialized memory from the stack or a
register to satisfy the %u specifier, resulting in a garbage thread name?

> +	if (IS_ERR(worker))
> +		return PTR_ERR(worker);
> +
> +	WARN_ON(dev->worker);

[ ... ]

> diff --git a/drivers/misc/arm-cla/cla-sched.c b/drivers/misc/arm-cla/cla-=
sched.c
> new file mode 100644
> index 0000000000000..6b5b782ac33e9
> --- /dev/null
> +++ b/drivers/misc/arm-cla/cla-sched.c
[ ... ]
> +void cla_domain_schedule_reassignment(struct cla_domain *domain)
> +{
> +	struct cla_ctx *ctx =3D domain->assigned_ctx;
> +	unsigned long delay_jfs =3D 0;
> +
> +	lockdep_assert_held(&domain->lock);
> +
> +	if (domain->broken || ctx =3D=3D &invalid_ctx)
> +		return;
> +
> +	if (ctx && !cla_ctx_is_dying(ctx))
> +		delay_jfs =3D msecs_to_jiffies(CLA_SLICE_MS);
> +
> +	kthread_mod_delayed_work(domain->worker, &domain->reassign, delay_jfs);

[Severity: Medium]
Could this lead to timeslice starvation?

By using kthread_mod_delayed_work(), the timer is reset to delay_jfs (100ms)
from the current time. If new contexts fault and are added to the queue,
this function will be called again.

Does each call push the timer back, effectively giving the currently
assigned context an infinite timeslice as long as new faults or wakeups
keep arriving, starving all other contexts in the queue?

Would kthread_queue_delayed_work() be more appropriate here for normal
timeslice tracking, since it does not push the timer back if it is already
pending?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015142552.4128=
028-1-ryan.roberts@arm.com?part=3D8
