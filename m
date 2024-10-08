Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF237603F;
	Tue,  8 Oct 2024 09:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728380475; cv=none; b=UPuqMbLRM/emlA1sIghj5gIDc1IJ1sNVkOB5i8D/af/6R/3x8tORefHeE3PpX3JM8cnz7z2noycpjITB/eGxEChYK6VgomvzequSGvWZyDk5g7RQQ9rPi18fNWNC8/dEC++5eL+wOs8mqjhI7dlGPWMnKUf52z9ELwN/eEPcP1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728380475; c=relaxed/simple;
	bh=ubTzCnBC70KHC7O0aTbMbYjDHYJmopdaE+9zq3mfv1A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=miNwq1G/0rhmgdVFjkcP3lL5oyiCkcIxiH2pIu2HjEefLqzXzqwPSIuX4EKvVCUC3DyTRqqEgwZewHT0CEgSwA+qB7hcCio8nugGmOvg1nBcFovJk8NmQ7aN1+XNLMXpXQwwDTvda7opBwD/LEvWLKP3Dl2tJ2nk88qSjtZoOjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knn9fQIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knn9fQIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ADAC4CEC7;
	Tue,  8 Oct 2024 09:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728380475;
	bh=ubTzCnBC70KHC7O0aTbMbYjDHYJmopdaE+9zq3mfv1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knn9fQIiZp0q44ylFNEamf331oun6iH6loPflvCnXKc44nO1Md5zOkN5st6w7IVM5
	 g1xiTKCrbTKNDEPU2OhAjzapCZP9FlV3ZgA7gX3jRJy1gn3gt7iL77iHK1RLjsQqqf
	 9moPQVUxemoHmBictfsNZRFkODdca8iu8GZNoCHn9B1K2I63zLlSENJl4fsRYrBAsS
	 mxhWsCFVdJedZrhjFFPsXEiaxwAKAYv5EzIsHbhm+g9sok6VS6LjVKIWYM4iIM9vnH
	 Fix2z/5Nrmu62WhpBVTLvu2cV+Pl6gYFulA15I5zmd2CVJ7Cvy/L7LdRhMrr/ipWMc
	 g1CLYddp7EmZg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sy6iO-001J7I-TQ;
	Tue, 08 Oct 2024 10:41:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Unregister redistributor for failed vCPU creation
Date: Tue,  8 Oct 2024 10:41:10 +0100
Message-Id: <172838046104.2971841.1504779240807802411.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241007223909.2157336-1-oliver.upton@linux.dev>
References: <20241007223909.2157336-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, stable@vger.kernel.org, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 07 Oct 2024 22:39:09 +0000, Oliver Upton wrote:
> Alex reports that syzkaller has managed to trigger a use-after-free when
> tearing down a VM:
> 
>   BUG: KASAN: slab-use-after-free in kvm_put_kvm+0x300/0xe68 virt/kvm/kvm_main.c:5769
>   Read of size 8 at addr ffffff801c6890d0 by task syz.3.2219/10758
> 
>   CPU: 3 UID: 0 PID: 10758 Comm: syz.3.2219 Not tainted 6.11.0-rc6-dirty #64
>   Hardware name: linux,dummy-virt (DT)
>   Call trace:
>    dump_backtrace+0x17c/0x1a8 arch/arm64/kernel/stacktrace.c:317
>    show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
>    __dump_stack lib/dump_stack.c:93 [inline]
>    dump_stack_lvl+0x94/0xc0 lib/dump_stack.c:119
>    print_report+0x144/0x7a4 mm/kasan/report.c:377
>    kasan_report+0xcc/0x128 mm/kasan/report.c:601
>    __asan_report_load8_noabort+0x20/0x2c mm/kasan/report_generic.c:381
>    kvm_put_kvm+0x300/0xe68 virt/kvm/kvm_main.c:5769
>    kvm_vm_release+0x4c/0x60 virt/kvm/kvm_main.c:1409
>    __fput+0x198/0x71c fs/file_table.c:422
>    ____fput+0x20/0x30 fs/file_table.c:450
>    task_work_run+0x1cc/0x23c kernel/task_work.c:228
>    do_notify_resume+0x144/0x1a0 include/linux/resume_user_mode.h:50
>    el0_svc+0x64/0x68 arch/arm64/kernel/entry-common.c:169
>    el0t_64_sync_handler+0x90/0xfc arch/arm64/kernel/entry-common.c:730
>    el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Unregister redistributor for failed vCPU creation
      commit: ae8f8b37610269009326f4318df161206c59843e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


