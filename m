Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEF4412C1D
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784053547; cv=none; b=uTjBg48SDi99d0KSpiuldmrmYGAKV+S7yDtIV78GEr+9DC88giBJ945pTaVELd9k1ED+182T8bLzM+0ohX0cr3WOonH+Jsrg9M47JxheVB3HyR2sNFlpGYFfmcHe5qFfHPnv9nG5qkasacjEZ6AFzwKUGnQtdbfGKPqmpUFZzuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784053547; c=relaxed/simple;
	bh=UJxitkdaPC5SZC4R34vCKL7FkTZNjaFflB5Ik5kfwb4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UGQE9WX3RxfBQMK3pR4/Je48cBemifTfa/x1TLT1mp3jjCDTIH4+b13JK6qnGRIAd8blBIytHHq0DH8VT2X8TxXNVUSDXL5Oc7a00OixV5ZLEQqjWJ8kRFHz8OTRuCmYUBnqK12pz8sYgYNUL26hTmAAr1ZJug3p/92DNI95WXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMyvq7jc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMyvq7jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33421F000E9;
	Tue, 14 Jul 2026 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784053543;
	bh=GtoP/ip2x5uO8OzulHUDfJIe+9sD61VUdNQYhX9tTHw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SMyvq7jccJmpo1IWoRpUVVwJO2Vz2gtQmSAkby/X1xjXEBHs2ndIHaRAg3T9E+Mdk
	 oWQ1N65guRcnJZm0rzdjS4ZlNZj5rOSewvctHxOrwuHsB2Czx6rou9cH6pYutlH5Np
	 y0I/nzyFe606I3l8qw1Pk/UoOyqXFfADGgkcN3iSwSLxETU8yDkjwOiqhx8If/lbI8
	 KhwJIE40xCLxorViUseNTC7I0hjV48FK+RgDTii0fp1yST0VeYbZKHGgHT5SYh5EP3
	 IKKftH3kCrEwhZJYU8DKhzm1yJfMusvE7myOr7dF2yveBI4jxi/Lx1w5UyHbfVdC3u
	 DhtM9dm643VTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix hyp_trace clock disabling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260714181010.2527225-1-vdonnefort@google.com>
References: <20260714181010.2527225-1-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 18:25:42 +0000
Message-Id: <20260714182542.F33421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing cleanup in the error path of `hyp_trace_enable_tracing()=
` leaks the clock synchronization delayed work. Furthermore, this patch int=
roduces a workqueue corruption if tracing is subsequently re-enabled.
--

--- Patch [1]: [PATCH] KVM: arm64: Fix hyp_trace clock disabling ---
commit c37a59b3ffe1e163385bedc8f21496d8af6fbc61
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Fix hyp_trace clock disabling

This commit fixes the disable path in hyp_trace_clock_enable() by returning
early instead of re-initializing the clock. It also cleans up the unused
lock and redundant running state from the clock structure.

> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 2411b4c32932c..0b03117a38ecd 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -37,8 +37,6 @@ static struct hyp_trace_clock {
>  	u32			shift;
>  	struct delayed_work	work;
>  	struct completion	ready;
> -	struct mutex		lock;
> -	bool			running;
>  } hyp_clock;

[ ... ]

> @@ -110,12 +108,9 @@ static void hyp_trace_clock_enable(struct hyp_trace_=
clock *hyp_clock, bool enabl
>  {
>  	struct system_time_snapshot snap;
> =20
> -	if (hyp_clock->running =3D=3D enable)
> -		return;
> -
>  	if (!enable) {
>  		cancel_delayed_work_sync(&hyp_clock->work);
> -		hyp_clock->running =3D false;
> +		return;
>  	}
> =20
>  	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
> @@ -128,7 +123,6 @@ static void hyp_trace_clock_enable(struct hyp_trace_c=
lock *hyp_clock, bool enabl
>  	INIT_DELAYED_WORK(&hyp_clock->work, __hyp_clock_work);

[Severity: Medium]
Is it safe to remove the hyp_clock->running check above, considering how
errors are handled in hyp_trace_enable_tracing()?

Looking at hyp_trace_enable_tracing(), if the hypercall fails, the error
is propagated but the clock is not stopped:

static int hyp_trace_enable_tracing(bool enable, void *priv)
{
	hyp_trace_clock_enable(&hyp_clock, enable);

	return kvm_call_hyp_nvhe(__tracing_enable, enable);
}

If the hypercall returns an error when enable is true, the user might
try to enable tracing again. This would result in a second call to
hyp_trace_clock_enable() with enable as true.

Without the running check returning early, the code will fall through and
call INIT_DELAYED_WORK() on the already active hyp_clock->work item. Can
this corrupt the workqueue list pointers?

Even though the hypercall might currently be prevented from failing due
to the remote lock serialization, should we add a rollback to the error
path in hyp_trace_enable_tracing() before dropping the running state check?

>  	schedule_delayed_work(&hyp_clock->work, msecs_to_jiffies(CLOCK_INIT_MS)=
);
>  	wait_for_completion(&hyp_clock->ready);
> -	hyp_clock->running =3D true;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714181010.2527=
225-1-vdonnefort@google.com?part=3D1
