Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3462820B7
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829692; cv=none; b=kXIxUsJa+eL8Cn+pnk18bp1vIdcUcWnynYGzXnBCkZEuumY05d8BN6m1FIv1o+fIFJdzPGXJnQ/ux2gyTloiVkzbknRib1Zo2ODpYQ/rBFIDGRPaOOz6xamYeeVJMQRzOIN8f+9+B6hp3T8eNWk3hsJMBBrfVw+FEG8/jZ8RHVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829692; c=relaxed/simple;
	bh=+s0ingcyIynwN0QqOokA30dWONviuLrNc+vRCAq2gq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dGUHkTVBB3nO3znDcGmgJa4wR1PsK7NRbxopfpAZ4e7oLRJU0sdArlhn9j2c5axDrUwpfxb/mTaq9npMS0X/dkjyg96299K5rKiSYfA/TWaRt45yp5nlnHxWll1AaBKDG04HnbqI/4HmAmQ74vMPOq9hafIO+h1rlW/Rj1RW204=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dqNe8cGL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dqNe8cGL"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3f33295703so7979326a12.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829690; x=1754434490; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9IvAMOvcbhlU5W8QZLEdB4U1p9VX42TgZ9WfVdMPu+g=;
        b=dqNe8cGLH/6sNayFCq5OUXvzyGGVsMRk2cJd42FXqJSyQkXMYnG++mWP1oZqEST7u0
         o5en3t5C5dXor5u78kSVM3MRthTcwYvk52LW7U9FKTXoDDTs+deMjd4lHNaFhg5GCeKw
         FVrCrrVclvroATwM1ZyJSFKHUTFDwoyAglz4c/vtiWWTveaI0fsv2piSyxcfSqsLA38O
         DeojbdLgZeMqEXgY2t18gn5Ki/wwP0CSBEf++j6QJaiVj4EVEx9nfUJhrgDfSDEQ5BOV
         qjwlEyT6qkAuZII7LKeknOMoWQRifsWrThyXzTG5UE4hL5oN1CCj3LnLiNvm3xlD8KOL
         7bPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829690; x=1754434490;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9IvAMOvcbhlU5W8QZLEdB4U1p9VX42TgZ9WfVdMPu+g=;
        b=L7orMqO6H62pqXXRchWOQtO3WmFAPNj86Nxe0CyJal/koJ+i8VqNfjYTfjmO8O7IPf
         utDsAhOzgqnoZdTs/OrlVzgVMjnrr6geFlS8VHzy7xxqEImcza5QshmM6j/qh8mMlhC2
         OKk8jma6PaOEWmlljRK7k63O//dXvj3Hhesqo8WPJzx9PzVZ6XTqkO6plPpgN1nm6TR9
         c/iAY7/DwPC3qdY8wMvxgKl2wsTNKuSZXUPYYbQlJEvMxppLFhSYpvxZZ4aI5wBHZg0L
         B3vH+iD/Y5mVDSgSLxTR2U/mnLg6Pxl+ClHx3P9V7zsQFux5nGO3k+8kEDZHSVbjo50u
         t/5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU10QZdmxQ+pikfcevhxV2ueN7UhBCXhFUJ4P78RY3Nuu1gZmvJmXcMMyh1n9T1S0H3fyx290k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/XANAbov4Pd7qPxRnhAY6EL4Ojg5c8wkTrBmNPk7UsfTQydps
	unSNt+kzyX7JHlf65OOLCSRXsv8qKgwD4DBgtj6h3kkX11tpK38JqEFxpUGlgZpeyYO7PpLd8SP
	tD32cTg==
X-Google-Smtp-Source: AGHT+IGQQ1/q92PLrkeNoYQwXKazYVHZno9fNiuzRJmcVNPJlU7fDI+A2fWwC+0aM4sd5YoKaOkjLYsx6S8=
X-Received: from pjk12.prod.google.com ([2002:a17:90b:558c:b0:31f:3227:1738])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0c:b0:311:abba:53d2
 with SMTP id 98e67ed59e1d1-31f5de42527mr1515007a91.17.1753829689699; Tue, 29
 Jul 2025 15:54:49 -0700 (PDT)
Date: Tue, 29 Jul 2025 15:54:48 -0700
In-Reply-To: <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com> <20250729193341.621487-3-seanjc@google.com>
 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
Message-ID: <aIlRONVnWJiVbcCv@google.com>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	Adrian Hunter <adrian.hunter@intel.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-07-29 at 12:33 -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 3e0d4edee849..c2ef03f39c32 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1937,10 +1937,8 @@ static int tdx_handle_ept_violation(struct kvm_v=
cpu *vcpu)
> > =C2=A0
> > =C2=A0	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
> > =C2=A0		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
> > -			pr_warn("Guest access before accepting 0x%llx on vCPU %d\n",
> > -				gpa, vcpu->vcpu_id);
> > -			kvm_vm_dead(vcpu->kvm);
> > -			return -EIO;
> > +			kvm_prepare_memory_fault_exit(vcpu, gpa, 0, true, false, true);
> > +			return -EFAULT;
> > =C2=A0		}
> > =C2=A0		/*
> > =C2=A0		 * Always treat SEPT violations as write faults.=C2=A0 Ignore t=
he
>=20
> The vm_dead was added because mirror EPT will KVM_BUG_ON() if there is an
> attempt to set the mirror EPT entry when it is already present. And the
> unaccepted memory access will trigger an EPT violation for a mirror PTE t=
hat is
> already set. I think this is a better solution irrespective of the vm_dea=
d
> changes.

In that case, this change will expose KVM to the KVM_BUG_ON(), because noth=
ing
prevents userspace from re-running the vCPU.  Which KVM_BUG_ON() exactly ge=
ts
hit?
