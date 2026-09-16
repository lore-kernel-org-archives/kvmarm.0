Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7712A4E50C4
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 19:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789585695; cv=none; b=Py+3HZWfPHw2JhLTGT6AVykgaaJb+ZMohMErYMqY7OsMZQKNddb+hFUXnBUYA8TRdlF+1zOlANkgDG/K0lQRpIPFasAVHO7acss5TkIma5lGVyTQrsqCnMqIGVDBqkfrWVklTv0kt4qGfuPYSGEjsZCe6oqm0NPVmVP9p67RzcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789585695; c=relaxed/simple;
	bh=+TDPxJtL8DsDFOfZOcxmuxXF09ysKs2kKWxtP5RDI3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cnAaARNAaFBle8QsyzUJEuxA+hPOS0NYNi/IPOmlvpS6ZWPYgbSNt5t9SORzNJhYki4ZXohe2HdPmJkkGf/KkOUSW/J6knXACvLehmm/nEG5eNoCY11h47vCq8QN8BOclrwOuHlqVYhpr4nginG+z8uYGiQEEaIpYqxqDpOmURU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F5S97VhH; arc=none smtp.client-ip=91.218.175.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F5S97VhH"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+TDPxJtL8DsDFOfZOcxmuxXF09ysKs2kKWxtP5RDI3c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789585689; v=1; x=1790190489;
 b=F5S97VhHbTrKQ+zYGm5kMlJnLc7/zBAj23cQIAKRcTLqbRKe6qFSKitHErOejNAhzbj7eY7Z
 i/rYrKHt+IJBCV/h0IEjSiZVUYhguvU+nASFvBEi33g7m11/Xzyizh7JYZRc35xLUO8tLX3pW24
 79aOqBL6SdVydqsOycjRIc3g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a7b5c89586d71b95;
	Wed, 16 Sep 2026 19:08:09 +0000
X-Mizu-Trace-ID: a7b5c89586d71b95
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so1258e87.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 12:08:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxSIvviMH1mJe8gkv1yuC3qN+iITAgoatenKu6oTJ3ExiBGInCBZ3r0wSKzcM0MtOGZxClBTKA=@lists.linux.dev
X-Gm-Message-State: AFuF++l1Wck5WmCkXVYFXeKNR//O/KS4vFejZVo7ZMI/OFpiLlLZDR4A
	6dnGg77ks4OAOsdZQgQmj0xM13lbx1/ucOoCrH6dpsoK0+BMyrHfZNwh/cYNkBg+RiHxF+RPeCe
	Wo8IecLKrsa5o0BwJfhxVAypMCCCnGoJtR+Ks6JQm
X-Received: by 2002:a05:6512:2526:b0:5ae:b918:79d5 with SMTP id
 2adb3069b0e04-5b8baa4c0afmr22017e87.2.1789585684442; Wed, 16 Sep 2026
 12:08:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-16-fuad.tabba@linux.dev>
 <86a4ph5fb9.wl-maz@kernel.org>
In-Reply-To: <86a4ph5fb9.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 16 Sep 2026 20:07:28 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzCQkeXQQcCDwABLR2w+NTmKTG3V6RSmhzYNayaoYXw3g@mail.gmail.com>
X-Gm-Features: AcwNN1WM-tTkNGmfulRqkmQ-SKP25Un1Bu-f9T35yz7K6_Zjf4OVrGXAUm-nH7c
Message-ID: <CA+EHjTzCQkeXQQcCDwABLR2w+NTmKTG3V6RSmhzYNayaoYXw3g@mail.gmail.com>
Subject: Re: [PATCH v3 15/18] KVM: arm64: Reject host access to protected VM
 private state
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 16 Sept 2026 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
> > +/*
> > + * Once a protected vCPU has run, the host copy is not the guest's state,
> > + * and EL2 has read mp_state, which it does only at hyp vCPU creation.
> > + */
> > +static long pkvm_filter_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned int ioctl)
> > +{
> > +        switch (ioctl) {
> > +        case KVM_ARM_VCPU_INIT:
> > +        case KVM_SET_ONE_REG:
> > +        case KVM_GET_ONE_REG:
> > +                if (vcpu_is_protected(vcpu) && vcpu_has_run_once(vcpu))
> > +                        return -EPERM;
> > +        }
> > +
> > +        return 0;
> > +}
> > +
>
> I'm not keen on returning -EPERM for the ONE_REG stuff. For a start,
> X0 *is* valid on MMIO, and when you want to support LD64B and co,
> you'll need to show the actual data there.
>
> I'd rather return what is in the host vcpu structure, as normal.

I think we should keep the error, for the reason s390 returns -EINVAL
from ONE_REG on a protected vCPU and x86 does from the register ioctls
for protected VM types: once the vCPU has run, the copy is the VMM's
boot state plus what the exit handlers copy out, and the VMM can't
distinguish them. x0 on MMIO is one of those fields, but the VMM reads
it from kvm_run->mmio. For LD64B, EL2 would copy the operands out the
same way and the error could be relaxed to those registers. Loosening
later breaks nobody. The comment and the message do overstate it by
calling the copy "not the guest's state", and I'll reword both in v4.
More on the kvmtool thread [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTwCs8B4du2=rAdoTOpOfh64p5cbW902e5g0u6NZT=r=gA@mail.gmail.com/
