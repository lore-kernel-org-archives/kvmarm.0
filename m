Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744413B14D4
	for <kvmarm@lists.linux.dev>; Sun,  6 Sep 2026 17:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788715232; cv=none; b=K3xmEmXWE1e8I+55OaGZxBl36/utcoBYkoqHVsbJ1eHhocXjUtLTIp6nPPT1agwwUbc9oKDRWp4A7djqwh2T3STYliM3pHhKOHysevL+pQDm85Vx4zG8ZIWxhuPj0vvQBIyKx0GA1xo44Js4L1tK6MW9AJInGjDbtPLtwaeDxcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788715232; c=relaxed/simple;
	bh=u8iacqcgJsxhNvW+ZuwYdOLqp3W13cBHeJp8kF5zX5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kM7heDnvyJlJaD8Kj/0f4zWiiu8OOHXmTkEmpOFsy6+qVlrJOJaqiuodIbWJn70iFRGl+FLo2N6KWO8XKNUn/pNP6uK9Qa8ogXI0P7lRKGtzQZ0tAG7tdIvXZTURDSEziyiDKg+vGNS+LL0U7FldnORvoafv8BAMgwse/5uQdOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VSC4NYUI; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VSC4NYUI"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=u8iacqcgJsxhNvW+ZuwYdOLqp3W13cBHeJp8kF5zX5M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788715228; v=1; x=1789320028;
 b=VSC4NYUIAW4Blz3FfYY98GnpfNACN/AJniar8Uv2EwZbIyvDjGCHWaQU8Hdvu8qUUnU1pkA+
 2mpK9bhEMKR+gdOdBk+UK7ugm4yi8Q4I8WofPWBz/yn8q6OQe6Fjt/Z0y0UrvW/8iev/c1TofQL
 VU7Eydd64MhGZoIOtfrsJnv8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5adce06742fa2d68;
	Sun, 06 Sep 2026 17:20:18 +0000
X-Mizu-Trace-ID: 5adce06742fa2d68
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so4114e87.1
        for <kvmarm@lists.linux.dev>; Sun, 06 Sep 2026 10:20:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzkoHMw+4/dvNAVIq1Cb6W7cu4cNItX07cIqj+1hc4ySfnNK2YCatOpC57LEgOanl/vWG+Hhfc=@lists.linux.dev
X-Gm-Message-State: AFuF++nqGD42e7spGMG8RD7iB6uF/dDYUc0rQlOm4QOt+egDqMO3Zr1l
	tycq9aVKzfVtoicrL/PKSmBxTTQnfroNzX1Wv044XfqQFt4y1bPGpdPTtib41pxr9TjqI0IqLAn
	rKTGH3Se6S+RlpV434omQnTipfQMRtn7qwC1WyQLE
X-Received: by 2002:a05:6512:2385:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5b74d44acb5mr105182e87.9.1788715216132; Sun, 06 Sep 2026
 10:20:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904175550.430266-1-dongli.zhang@oracle.com> <20260904175550.430266-3-dongli.zhang@oracle.com>
In-Reply-To: <20260904175550.430266-3-dongli.zhang@oracle.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 6 Sep 2026 18:19:39 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzjDysJXhuFTyRdmh3Ds23r+S+SNghUH1RYpBfwHFTJWQ@mail.gmail.com>
X-Gm-Features: AcwNN1V6wsRuawKeQC5Yrt6FrQGQC2xcq6Of0g2I-XUsUdx59PQhL1xhMAbXFWM
Message-ID: <CA+EHjTzjDysJXhuFTyRdmh3Ds23r+S+SNghUH1RYpBfwHFTJWQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: Reset last_steal on vCPU pid change
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, zhaotianrui@loongson.cn, 
	maobibo@loongson.cn, chenhuacai@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, dwmw2@infradead.org, joe.jin@oracle.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Sept 2026 at 18:56, Dongli Zhang <dongli.zhang@oracle.com> wrote:
>
> KVM does not support vCPU hotplug. When a vCPU is removed, its
> corresponding data structures are not freed by KVM. Instead, QEMU destroys
> only the userspace state and the vCPU thread, while the KVM vCPU fd remains
> open and parked in QEMU.
>
> As a result, vcpu->last_steal is not reset.
>
> If the same vCPU is later re-created by QEMU, last_steal retains its old
> value, while current->sched_info.run_delay starts from zero since a new
> vCPU thread is created. This causes
> current->sched_info.run_delay - vcpu->last_steal to produce a large, bogus
> value.
>
> Fix this by resetting vcpu->last_steal to current->sched_info.run_delay
> when KVM vCPU PID is changed.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
> v1->v2:
>   - Move from kvm_arch_vcpu_run_pid_change() to its caller.
>
>  virt/kvm/kvm_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 65eb26a0520d..784f0d945b45 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4478,6 +4478,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                         if (r)
>                                 break;
>
> +#ifdef CONFIG_HAVE_KVM_PV_STEAL_TIME
> +                       vcpu->last_steal = current->sched_info.run_delay;
> +#endif
> +
>                         newpid = get_task_pid(current, PIDTYPE_PID);
>                         write_lock(&vcpu->pid_lock);
>                         vcpu->pid = newpid;
> --
> 2.43.7
>
