Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792790202;
	b=1iyMjoURmO4fWbPxrnzN5hsjigiV7AGOHYRyLlm11AhHn2Yde+c/Osy7dWG7wKkCyQUP
	 UNpZnqKcPok0ftDPl4ihFFEuttXObFEVIUDEfyfxsbDX3Qzq8kgN1PPb4bdqPiVCfbAOM
	 VGZMZrcxxLu7tD2/+HiaNkHSJF4kBvOxH6PY/WAgTrCvwcLzGtZLEk8AgASWNiFdYkDB8
	 LSMT3pqc50+jkplV0Hkh1gDVcg7b2AYQiZYkyjisbxMC7GyoUWGt+EtCYfLTztBMx7nqU
	 Vs7/G7GGOdNhldQiuJuSpt83s3DrluUDfjBo2okMdWsOKBZ54LYBldmhlcW+6I+SlFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792790202;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wi5XgSFRcy2SVWm6gBRpfaOjoU7j0YiPJ2Nt2VnRfyo=;
	b=vAfLgGVkvZOQonQO/ia9pONsuazmfQf3bkmkoDahzvHAYHICNkOCwxQFG6/ST/s7zY1n
	 4cGV3tuI2anNGoqLOputL1Mc7mHEoCuUZpgs6qHnp8rEPd7A9uhE435wNCttrUUZfX/jC
	 YH+MmcpKHYW/sEDx84VsUsqlW+mDExvq/PmHvBlueFfVKplX/DoePaVzGiZ8uD7nP3W5H
	 09IedWy2IYtwBfgPPg/CUnI65bQyJ34ZQO+12M4YxvSeJyjD3KtadkI6grdrtErE6oFGH
	 Xv13ZiUFLKlZHyl5qRhaqfZxTxXSbaFO0rVK31Iq2bm7WwVd89i0sd37kQs/E/SvigQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oxqPpOJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFCB606A324
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 21:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oxqPpOJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587001F031E0;
	Fri, 23 Oct 2026 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792790201;
	bh=wi5XgSFRcy2SVWm6gBRpfaOjoU7j0YiPJ2Nt2VnRfyo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oxqPpOJBhR3ASbaSz6mUUaRfuyU8lhBgEkZSH9pMU4sG+RYGvX5ZB27royEmLVj9l
	 uNnJq4jZx1vxVhAOgGNMNO6H+4lKErk5sWjQHprPl5sjRsdzdXlIrB28ZoQXgzZBAL
	 /1ZIjB4TFpYE3/Uzks7xtvgjPm8puVDnK28tX90FROcAMaTneHGteFqw8nOIYqolG/
	 i35S7b4R7JUt1VriylfOVUixdFNZoBB5Ak/LwFPuFpwIP1jmrBxiZvmhH+iiFougLf
	 uFByyTiwXt5U7M8gW/syabV+DXcdiw9I2yu0qDx88N3dad6ujyu7f4rFHrMPuG4wN/
	 UWtHGajokoDfQ==
Message-ID: <sashiko-outbox-183240@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/28] KVM: arm64: Reject non-coherent DMA when using
 forced writeback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261023205610.1044532-21-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-21-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 21:16:40 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM: arm64: kvm_arch_register_noncoherent_dma() bugs VM for cohere=
nt VFIO devs
--

commit e65fa223b5ab689dd29e0940ed61947cf8f5ac8a
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: Reject non-coherent DMA when using forced writeback

This commit implements kvm_arch_register_noncoherent_dma() on arm64 to mark=
 a
VM as bugged when non-coherent DMA is registered on a system using stage-2
forced writeback (ARM64_HAS_STAGE2_FWB).

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d593ba9280933..f08a450184d96 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -133,6 +133,20 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  	return kvm_vcpu_exiting_guest_mode(vcpu) =3D=3D IN_GUEST_MODE;
>  }
> =20
> +void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
> +{
> +	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> +		return;
> +
> +	pr_err_once("kvm: noncoherent DMA unsupported with FWB, see kvm_arm.nof=
wb\n");
> +	kvm_vm_bugged(kvm);
> +}

[Severity: High]
Will calling kvm_vm_bugged() here break VFIO passthrough for cache-coherent
devices on systems with ARM64_HAS_STAGE2_FWB that do not advertise
IOMMU_CAP_ENFORCE_CACHE_COHERENCY?

When userspace attaches a VFIO group or device file to a VM via
KVM_DEV_VFIO_FILE_ADD, virt/kvm/vfio.c:kvm_vfio_update_coherency() checks
kvm_vfio_file_enforced_coherent():

	list_for_each_entry(kvf, &kv->file_list, node) {
		if (!kvm_vfio_file_enforced_coherent(kvf->file)) {
			noncoherent =3D true;
			break;
		}
	}

	if (noncoherent !=3D kv->noncoherent) {
		kv->noncoherent =3D noncoherent;

		if (kv->noncoherent)
			kvm_arch_register_noncoherent_dma(dev->kvm);

That helper calls drivers/vfio/vfio_main.c:vfio_file_enforced_coherent(),
which queries IOMMU_CAP_ENFORCE_CACHE_COHERENCY:

	device =3D vfio_device_from_file(file);
	if (device)
		return device_iommu_capable(device->dev,
					    IOMMU_CAP_ENFORCE_CACHE_COHERENCY);

While VFIO and iommufd already require IOMMU_CAP_CACHE_COHERENCY at device
registration and bind time (__vfio_register_dev() and iommufd_bind_iommu()),
IOMMU_CAP_ENFORCE_CACHE_COHERENCY is much narrower on arm64. In
drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:arm_smmu_capable(), it is gated
on arm_smmu_master_canwbs():

	case IOMMU_CAP_CACHE_COHERENCY:
		/* Assume that a coherent TCU implies coherent TBUs */
		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
		return arm_smmu_master_canwbs(master);

And IOMMU_FWSPEC_PCI_RC_CANWBS is only set in
drivers/acpi/arm64/iort.c:iort_iommu_configure_id() for ACPI PCI root
complexes whose IORT node sets ACPI_IORT_MF_CANWBS:

		if (fwspec && iort_pci_rc_supports_canwbs(node))
			fwspec->flags |=3D IOMMU_FWSPEC_PCI_RC_CANWBS;

As a result, device_iommu_capable(dev, IOMMU_CAP_ENFORCE_CACHE_COHERENCY)
returns false on Device Tree systems, ACPI systems with IORT tables that on=
ly
set CCA=3D1 (ACPI_IORT_MF_COHERENCY) without ACPI_IORT_MF_CANWBS, non-PCI
platform devices, and systems using other arm64 IOMMU drivers (such as
arm-smmu, virtio-iommu, apple-dart, or qcom_iommu).

On any of those systems with ARM64_HAS_STAGE2_FWB, won't attaching a normal
cache-coherent VFIO device invoke kvm_arch_register_noncoherent_dma() and
immediately terminate the VM via kvm_vm_bugged()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023205610.1044=
532-1-oupton@kernel.org?part=3D20
