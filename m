Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144C83AA9D8
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 01:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785978858; cv=none; b=espwIKDCP+9tBghix5J7YGbR0HXNNN7WjWP7JK9BxBUAnWfAIlmq0PUyYjBmgtl4K4DX2R7watYez4yjRFHExmcD2Ny0IeVZUEH4GRlDtXvza3LDg4B67NsCcWxW6PQDbwJQcV3pk04Bvf2DIRVqrrMul5EeDKPcFaQHuWtGu7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785978858; c=relaxed/simple;
	bh=FnURd9znNvpM1kqH7h6q11jvcJIcgM8HdPz6ZSRX88c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sBSTktgeJoJd/LChvAqsOJ4O1mnEXCu8Vihx9TxirX8wKngjSAbnK6jZUDILrKfUV81lXya1YqKTETF1Dn+swEWJ5oSCL7ei0OmMDmgd+HMpN3+VVj4+nAvbGQfsZTM3v4QihJuImMJd6WHuJrFyFqg+zlwt1Rs3ynV7ypxuZbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tboHgdPE; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tboHgdPE"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca7c1e22995so2373330a12.3
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 18:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978855; x=1786583655; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EllBK4pohN2CB4+9rC08wwxbJTVXkdymq5nTAYfElqk=;
        b=tboHgdPEs+Z2Em47CsAbftP0I2c7gddGzC2qVP5BfTNERRd5FOQpnt2Tcw/F7bu8e6
         YyaL35PUq9u+eDrPQulXb9HeYJSKDQ096Hh4/t9fn8WjnsWHHuvl2Qu0W9nz3uZXk9vc
         S5OrvRyEBiESoAimTJ0YgrIkE1SJagDls7fo/ewBU8mTr0n5VgC6uWzbOSz/cQTOTVcb
         sUORAG/FpgX3Nz6tcjtggRbw4Fl3044HuZwuab12+UZRsB5vlGqyHoQuq7D0fkbINP3Y
         jpUU/+46mJ9NOHFvATu5hMpmYS7tiaAFg+9zCn8gWLOZY/GsR2ytsqdHfOeQGbexZgEd
         Ov1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978855; x=1786583655;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EllBK4pohN2CB4+9rC08wwxbJTVXkdymq5nTAYfElqk=;
        b=K83y2dTci6Vmzx3YRq6DSP1nejfs/TGNRorSQwIBXQdVthVnkOkHepH+IDSqcFAtwR
         PNxkyw9VfDbbFP58yXu+xHquTT02YS5PVqO1Me/SUYZyqZ5Vyd48Dk3h+mOciVc9np/z
         /DA2X9kETM36LPTn6uxTrK1wKoofq/i4Qe5blMcVB6+27fh6/rodPrOUQI1jsDsdmic1
         L6svSHcuqeFZoUN7/kbelGvFWXFCrrk/ASAplFFRgxBWZJIxFJzkBUpOyzmHQjmtR362
         HXwLuWOTWCIHMdBD+ghfJFrzwmCBLrp+hNtiT0Kr+nxtlggnU5FqPteVzzUdM8yslzIA
         TMPg==
X-Forwarded-Encrypted: i=1; AHgh+Rpo2ijdW8Vppp4pJDusvMw5RdeQalBqD6xghd+eC6E9fy0gx4aGGzCj1LWGjMRY3jHsOzc35D0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzajOe9ooKkkJypBccPl2e9Sn8k4JDRsBmO6SKy/IOdfVNLjxYx
	cahckPGl6/jjTk5y4u3hqd5uVXZwpZNwIPDNWOFUWfarg1QA3cmIf4XntjSsfZK0jlvdB4X1EgV
	4Yg2vOA==
X-Received: from pfbi27-n2.prod.google.com ([2002:a05:6a00:a51b:20b0:84e:99ac:46cc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c93:b0:84a:29a7:f650
 with SMTP id d2e1a72fcca58-84f2de6ab12mr11213223b3a.0.1785978855213; Wed, 05
 Aug 2026 18:14:15 -0700 (PDT)
Date: Wed, 5 Aug 2026 18:14:14 -0700
In-Reply-To: <CAEvNRgGDhcu2LUqhwVtGJSUo4uXQHrGOYRDaM2qzPTO4LX=jKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-4-tarunsahu@google.com> <20260728122655.17C791F00A3A@smtp.kernel.org>
 <CAEvNRgGDhcu2LUqhwVtGJSUo4uXQHrGOYRDaM2qzPTO4LX=jKQ@mail.gmail.com>
Message-ID: <anPf5lLNZ5OtwXor@google.com>
Subject: Re: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create()
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: sashiko-reviews@lists.linux.dev, Tarun Sahu <tarunsahu@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 30, 2026, Ackerley Tng wrote:
> sashiko-bot@kernel.org writes:
> > --- Patch [3]: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create() ---
> > commit 5e642ea16f0d267e622a352de60bfe397ecf79df
> > Author: Tarun Sahu <tarunsahu@google.com>
> >
> > KVM: Export kvm_uevent_notify_vm_create()
> >
> > This commit exposes the kvm_uevent_notify_vm_create function to allow
> > triggering KVM event notifications during VM creation.
> >
> > [ ... ]
> >
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -6348,6 +6348,11 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
> >>  	kfree(env);
> >>  }
> >>
> >> +void kvm_uevent_notify_vm_create(struct kvm *kvm)
> >> +{
> >> +	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
> >> +}
> >
> > [Severity: Low]
> > The commit message mentions exporting this function, but is it missing an
> > EXPORT_SYMBOL_GPL or EXPORT_SYMBOL_FOR_KVM_INTERNAL declaration?
> >
> > Without the macro, won't dynamically loaded architecture-specific modules
> > like kvm-intel.ko hit undefined symbol linking errors when they try to
> > call it?
> 
> I'm not 100% sure about the use of EXPORT_SYMBOL... here but usually I
> compile kvm as a module to try and catch these types of linking
> issues. Maybe Sean will have a better method/explanation for this.

The issue is the shortlog, not the code.  The intent is to make the function
globally visible, not to truly export it (the eventual usage is code that's
linked into kvm.ko, i.e. doesn't need an export).
