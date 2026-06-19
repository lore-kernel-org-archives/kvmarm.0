Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F967146A66
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854756; cv=pass; b=A/EIodgFBOSGLtPk8uFG1pz38bqtMWoDLbvMpk3pgi4MJ+1vdkNpxfKG3GO7IFLOFsUUb4ZCMij+DJvGbO3YGVqdZHmYMHqlaPYGWgbBUO07kPOrXCZkWCQDvRUESoT0fKd7xSOaDDAa2njftbm00e75Joy1gJT7qQUAZpbDIRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854756; c=relaxed/simple;
	bh=zJXixiUV6ozgi01k+ljr7Ir1SM2X4PT6aZDiJupUJaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dL38Etx3iSi54UNCV64hXQbP9y6mGn5Rlc9N9t0SOlq6uR/CuuYgy0Sq0DsewoTC/G0U5lhLcKC7juC93b+nu6zuC9p5+Rf2VSawfaA/b8fHMPJsDlDvsd4IXstkkZevtDoQqcLq3qoLs9W7GZpRtLSS1FR4G71R/iWjs8UE1yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iyND/EoL; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iyND/EoL"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-519ed52bcc6so92771cf.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:39:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781854754; cv=none;
        d=google.com; s=arc-20260327;
        b=AEX6MmNof7XxlHBlvuY8Xl+bJoAGhwMynEMzoViGmwMKNKgWtLPqCabNXLO2HvopBI
         /Ke3VsuSFuF6S5wC3sY6TPA+4v1q9OIfVFybF6i8K0Cjbie/SnqobuwCUzoiYXmt3TmE
         bVU2noPUon519QDdlCXJKHymQ8oneHUYuVVZwIRWwuiam3oJQiZiJujIZXXs4XfzZEwG
         G7VVMlh1v0V8/aGEtP/qjY8Fsjq+ir68r5Jam6CtfEacUbDaliKwfpFO8PAdUAgTH3ID
         lFcKL0Q4Br2lPsz36lJe9eruKuZ2VJwOfxjieT2+H53JApVAp+LRTTD4xYxUkozz4EgS
         eZyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b/nFhTAjhbJp5V/sD3tUrWU8hOfuirDxyHOeAez13Aw=;
        fh=HhTV4G5+xnJ3thQDc6cpcOYMN3AitX7qB0zPfKB89LY=;
        b=SVt8vU48a6AQ6O7Coj/av3Sg+ZUEoZu4LoyPrxOgNFt67l6vY/Vd191UYFQAAw1JW4
         YhA8Si8C4hf7NLnWq4d8Va1atW9XCMDVEyEQAxyzjdTONj6/PaopfNAQoV8PyAYr3Cl2
         sMMXjrD9YB9lfPB8Euue21H1Z/zzdiDHPlL7VSZxckc9+/a56rbEK7J2QRr3Okk+92zy
         r5uawup0cveyeHXRtGuebDgOCxwcA0Gntk3o5guGhGxrDKW50s3h49kuPvrRRcenfui4
         BddnOCRGeYwNeHfowQHWDDyzyIoXGNQuUQCpDdQYklZEwrqCAbfyFw0kDrGBWNaN82Ws
         n1QA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781854754; x=1782459554; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b/nFhTAjhbJp5V/sD3tUrWU8hOfuirDxyHOeAez13Aw=;
        b=iyND/EoLy9DN+OZnMvOx28ro6psPGPRrRwJHfFlpDB7fxsyr164ns/Sj8Zbl/uplB1
         674n8bEq/ZRL7j3Y/ZdmwG5Lnit11nnqZkNh0JhUKNPBBgQM+wLYELhkIubUPuhIQYOi
         tjHVD59g5lh4k7eE3CFuXBw7PJuay3bEPRoPC1Appnp1ZhybZU3QTSwBp7ILiMEQr1hO
         zvGC0qPMs5UKw8Ra8tZUMoURO+JxctA+Q+yDfdlIA2h4dgL6AFRini8fhYY5YFubokA0
         64rcexH3XRMJm6BC8bYjlX2PnZNTOfPQLtaNtqihAakdLKO0rPdOIkXpddllScFBVdX+
         enIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781854754; x=1782459554;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b/nFhTAjhbJp5V/sD3tUrWU8hOfuirDxyHOeAez13Aw=;
        b=SSiSZfkKwn9qC+MVE9AAm4xnDhcJUKhBvjpbnSjkHbkT2lnlb/N1/YCp8ENB9fvV4g
         lIgCOQ1RkX7PtRYqfHBPlWkQTpboAbBczJroLahHeHy0DQ9Dq5Ty23DZgltif0fabvfH
         +rlmwQP/y7o6D4MT4N7kCX/9LEPxCyWueNiEm+vhzo5/rCoKp34hbLzhypISybdjBsWs
         +yK+OAkPTQAIxM5gUAmWV29eonuPxhT8oo1qN6Yv3RtP2kUg/eputkLejXqlTEqCUhro
         oUkYFhVEsXXD/+IC02EQx0+aWdJoZ4GAx2PSYG9hhYn4TmWGDEbPs76ZoUlpqOiPiiI/
         6b6A==
X-Gm-Message-State: AOJu0YwTrnaPSY26Z/Up0QBZYpDmxIJCpkigBGNzcIU3+qt3SfRlSSM8
	J3pD3JaJ6fqPTQWkHp0IwbCAPi7Vg9XjzkJeqD+DG1QRt1DUSRBFh9vSFiCQcJOcT1dNP8ZtsmM
	ZZNFp78i1e4MILhwF6C+y2/3gcB6y3F0r6fHWL+2xZYra9NMhbE/G+45Qprs=
X-Gm-Gg: AfdE7clxSRjdCz94xKoXwo9aHmKN/9SL9wL49ntdrmMa8aALTOa32hVw7ywb7RX+8rc
	/u+ZOiwOGOqymXbWQEyyRJW1dF68oc91HIuPf3gPgviAKlylpbUJH3YAE8gmaY5oiCvr4GTau8Y
	NPKJWYl8vYJC4YpRu3ZA88mEhdfW3++FXWeCdu6UMVmxUradBozgu5KigyBAJe5eMAuSsUG7Bb2
	Kw7No2uVUCg/pQPS+Rz4JASwBncoyd0gF0Vh8Xd7euXtra9+wJzkl4EvakD2q7KVsUck0vdsw==
X-Received: by 2002:a05:622a:8cd:b0:517:99ea:ab80 with SMTP id
 d75a77b69052e-519e4aa1aaemr6011001cf.26.1781854753815; Fri, 19 Jun 2026
 00:39:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com> <20260619070719.812227-7-tabba@google.com>
 <20260619072548.759B01F000E9@smtp.kernel.org>
In-Reply-To: <20260619072548.759B01F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 08:38:36 +0100
X-Gm-Features: AVVi8CduQOgG0CMBvLj8ydTJYtRvU_LW2yrTVdxsY34sqWe4GB9vlgNfLFOVnzU
Message-ID: <CA+EHjTySrnCwLy2F4GoNhHie5pv0wHdRzgDi5DdO7VPEd90cuw@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jun 2026 at 08:25, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [High] handle___vgic_v3_save_aprs incorrectly clobbers the host's vgic_=
vmcr with a stale value.

The VMCR copy in the hyp_vcpu path is redundant with
sync_hyp_vgic_state, not a clobber. __vgic_v3_save_state reads
ICH_VMCR_EL2 from HW at guest exit, then sync_hyp_vgic_state copies it
to the host. The save_aprs handler writes the same value again. The
only writer to host_cpu_if->vgic_vmcr is vgic_v3_set_vmcr (GICv2
distributor MMIO emulation), which is userspace-driven and runs
outside the vcpu_load/vcpu_put window.


>
> Pre-existing issues:
> - [Critical] The patch fixes arbitrary host-pointer dereferences in the V=
GICv3 save/restore hypercalls but leaves the exact same isolation bypass vu=
lnerability open for GICv5 equivalents and handle___kvm_adjust_pc.

GICv5 is not supported in protected mode (is_protected_kvm_enabled()
gate in vgic-v5.c skips device registration entirely), so the v5
handlers are unreachable. handle___kvm_adjust_pc and
handle___kvm_tlb_flush_vmid_ipa are pre-existing upstream
unvalidated-pointer hypercalls, not introduced or modified by this
commit. They are fixed as a group in a subsequent series.

Cheers,
/fuad

> --
>
> commit a6f1c910e601736a7f5d9f267e781560d10966dc
> Author: Marc Zyngier <maz@kernel.org>
>
> KVM: arm64: Minimise EL2's exposure of host VGIC state during world switc=
h
>
> The host passes a vgic_v3_cpu_if pointer to the __vgic_v3_save_aprs and
> __vgic_v3_restore_vmcr_aprs hypercalls, which EL2 dereferences wholesale.
> This patch recovers the host vCPU from the supplied cpu_if via
> container_of() and copies only vgic_vmcr and the active priority register=
s
> between EL2's hyp-side state and the host vCPU.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 45d717889f6ea..f3233ee343a39 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > @@ -508,16 +520,63 @@ static void handle___vgic_v3_save_aprs(struct kvm=
_cpu_context *host_ctxt)
> >  {
>
> [ ... ]
>
> > +             host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> > +             host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;
>
> [Severity: High]
> Does this overwrite the host's updated vgic_vmcr with a stale hyp copy?
>
> Since __vgic_v3_save_aprs() does not read the hardware ICH_VMCR_EL2 regis=
ter,
> hyp_cpu_if->vgic_vmcr retains the value it held at the last guest exit.
>
> If the host kernel emulated a write to the guest's VMCR (for example, via
> vgic_v3_set_vmcr() during a trapped sysreg access) before the vCPU thread
> is preempted, this explicit copy back to host_cpu_if will discard the hos=
t's
> emulated state changes.
>
> [ ... ]
>
> > +     } else {
> > +             __vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> > +     }
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but since this patch secures the VGICv3
> save/restore hypercalls against arbitrary host-pointer dereferences,
> should the same protections be extended to handle___kvm_adjust_pc and
> the v5 equivalents?
>
> Currently, handlers like handle___kvm_adjust_pc() still pass unvalidated
> host registers directly into kern_hyp_va():
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_adjust_pc() {
>     DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
>     __kvm_adjust_pc(kern_hyp_va(vcpu));
> }
>
> Because kern_hyp_va() is idempotent for addresses that already carry the
> hyp linear-map tag, an untrusted host could supply an EL2 linear-map
> pointer that is returned unchanged.
>
> Passing an arbitrary EL2 memory pointer here will cause __kvm_adjust_pc()
> to read and write flags directly at that address, giving the host an
> arbitrary EL2 memory corruption primitive.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070719.81=
2227-1-tabba@google.com?part=3D6
