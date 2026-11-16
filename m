Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794816439;
	b=Q6qTmHLQGgvGoJ5PqAaXS8szM0IZ/m2NnL/Rj1FHEA6MYtn4dwMx5CcUVhbTyd92DYYm
	 ZamvsWE3FQnBuhy2gbiYzQsjyjxFBOCaI2qgpyM6oydyqzE0rbVr6LwvCheo8RyErweWM
	 X2mcbHAqgVEVTilIbLxNFB1MGOEhppPdtZriJRfybdM1KAp1gT8EZkSAHAiN6xa9Q9E06
	 SYZx2stPXUR5Jhwx//TwBxVaw88SZx/v7trd2/Tf5cwcNYQZG1/MX2+MrwCEKZ5UrJmW6
	 PLNZZGcMCoLwUK6/QjQ+55uUN1q6bpNXnHURD5/tL7rD1F73rgxj9CTTCcBOApSPC4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794816439;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2gmpRxb8gQ1bNObRSr0Uai6JC9BUASRtSm25oFPH37k=;
	b=jRYPXKFMgg1o7yCVzr/O3ydiyMmw9TGPwzJvb+PGdefznzchnUk7fmCdFx8K8XcaF+X2
	 66TmyVcu+fc199GCe0w0+r2IEIAbjMLAsWyos4jyn4bhXDCm0SGX0jMIiaZctAIdfrNFV
	 OCK0fVRIrf3Bf/se1OedcD1jUT6oHZT3pJijqzudsVP+zR6yS/jnUJ4cCDca5HQSP1g6J
	 oNAQhZshbFLt0fj7Xlpnz9G9S4Jam+sq9ed4ew6gCEegK6A4ZktiG4vb9vyjPKIuROVvz
	 2iOHqn1Uf79shIzEEKXL9TEotRqGq/rtJdE0/Q6HDbO+Hy+pgYMNqthpu1HB4CPPabQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DRtA3bpX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6F1606A31C;
	Mon, 16 Nov 2026 08:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DRtA3bpX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A90C1F000C4;
	Mon, 16 Nov 2026 08:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794816438;
	bh=2gmpRxb8gQ1bNObRSr0Uai6JC9BUASRtSm25oFPH37k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DRtA3bpX/eUT/rX2maLdKgu3dE/wvhdhrc5ezjzyJWpU61ECINB0UPCRRK9wBn44X
	 YWMlEJJ8ER4OUiz1kpKAjJCbh0zSRvT3NBF1RgfaeGqJbGQQ7ZZ/ok0jSoTKJd3i83
	 Bt320IYx5iALR0969RGlmdIVcCGD9bhRMz+0x3BSgRjrhDEsUmdlfRC9l8sAqZPQ9n
	 uNw8c56ogQtJyTcMTJsKXcmSSyZq/pwKUklAt+8hph8RTsfvGQKokbCgnLkZ/jgV7w
	 5OJqxKUU1HMwofBEfS0XW0RfCxDejuFllPUv5l5kmVBjNFIx9yYNFIYfZcBlRKQQPz
	 x2lvrfBSGsY7g==
Message-ID: <sashiko-outbox-216506@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: gic-v5: Don't move the vPE doorbell
 from kvm_sched_out()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jia He" <justin.he@arm.com>
Cc: kvmarm@lists.linux.dev, linux-rt-devel@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20261116071304.2037895-3-justin.he@arm.com>
References: <20261116071304.2037895-1-justin.he@arm.com>
 <20261116071304.2037895-3-justin.he@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 08:07:18 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: gic-v5: vgic_v5_load() in WFI disarms doorbells
  and loses wakeups
--

commit 36844cdbda4df2b177b6c013c2074287d75ff5f3
Author: Jia He <justin.he@arm.com>

KVM: arm64: gic-v5: Don't move the vPE doorbell from kvm_sched_out()

This commit skips calling irq_set_affinity() in vgic_v5_put() when
vcpu->scheduled_out is set, avoiding acquiring irq_desc and pi_lock under t=
he
runqueue lock during kvm_sched_out().

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 91810fbd99afa..5824b00bb50df 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1248,8 +1248,14 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
>  			 * Make the doorbell affine to this CPU, if it isn't
>  			 * already. Actively check the cpumask first as it is
>  			 * cheaper than changing the affinity every time.
> +			 *
> +			 * Don't do it from kvm_sched_out(), which holds the
> +			 * runqueue lock: irq_set_affinity() takes the
> +			 * doorbell's irq_desc lock and may wake its irq
> +			 * thread. The doorbell works from any CPU, and the
> +			 * next WFI entry moves it.
>  			 */
> -			if (!cpumask_test_cpu(cpu, aff)) {
> +			if (!vcpu->scheduled_out && !cpumask_test_cpu(cpu, aff)) {
>  				int ret;
> =20
>  				ret =3D irq_set_affinity(db_irq, cpumask_of(cpu));

[Severity: Medium]
Should vgic_v5_load() bail out when IN_WFI is set instead of only skipping
irq_set_affinity() here?

Because vgic_v5_load() does not check vcpu_get_flag(vcpu, IN_WFI), any
kvm_sched_in() while the vCPU is halting in kvm_vcpu_halt() calls
__vgic_v5_make_resident(), setting gicv5_vpe.resident =3D true and clearing
ICH_CONTEXTR_EL2_DB in hardware.

If the vPE doorbell fires while blocked in kvm_vcpu_block(), db_handler()
sets gicv5_vpe.db_fired =3D true and wakes the vCPU thread. When the thread
schedules in, vgic_v5_load() makes the vPE resident before schedule() retur=
ns
to the loop in kvm_vcpu_block(). If the vCPU thread is preempted again befo=
re
kvm_vcpu_check_block() consumes db_fired, kvm_sched_out() -> vgic_v5_put()
still calls __vgic_v5_make_non_resident():

arch/arm64/kvm/hyp/vgic-v5-sr.c:__vgic_v5_make_non_resident() {
	...
	WRITE_ONCE(cpu_if->gicv5_vpe.db_fired, false);
	cpu_if->gicv5_vpe.resident =3D false;
}

When the thread schedules back in, kvm_vcpu_check_block() ->
kvm_vgic_vcpu_pending_irq() sees db_fired =3D=3D false and goes back to sle=
ep in
schedule(), losing the wakeup.

Making the vPE resident on schedule-in during halt-polling also disarms the
hardware doorbell for the rest of the poll window, so newly pending SPIs and
LPIs do not set db_fired, and a subsequent kvm_sched_out() still runs the E=
L2
residency hypercalls and vgic_v5_sync_ppi_priorities() under the runqueue
lock. Returning early from vgic_v5_load() when IN_WFI is set keeps
gicv5_vpe.resident false throughout kvm_vcpu_halt(), so kvm_sched_out()
returns immediately in vgic_v5_put().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116071304.2037=
895-1-justin.he@arm.com?part=3D2
