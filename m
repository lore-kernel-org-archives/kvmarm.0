Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C283155398
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 20:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731011209; cv=none; b=g5hs6a2062cZV4bFHAMtD02Nd75IAhYNfMp81swxnGte8xlc/yK+dlC0F6Fd4o6kjyeBbcKxupi6RqiJK8xX9WmNCZhudOvZCnYFYwU8lAl0n6oU+S6hkHh1rK2wSLJ1JPmgt8BWAtfR/049v0JPfHVWbSZvMLI3pNe0CgnHyO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731011209; c=relaxed/simple;
	bh=5+dKjp4NFaoQsFGHLDX4etrIGMptFEHaNLPNJNjWcpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fPaBm0ySJefBVHNnHVjCVCZcHNxA4ocJamldj+RJnozrWiIZxxhg0/+vY2CuwUz3s8f2TcYpNFHfHP+jvgfppZ2sLIZYTDBo1AiahbBlyA3FtGHCo2v9oVD4n8LfHmxW9glVD6ssuuAqhYMRDi/lPg7+rmb2+iTvMePZb6VyBOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h0blL6qy; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h0blL6qy"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea9618de40so24125347b3.3
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 12:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731011207; x=1731616007; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DaXja48Eoul2mL0v8OhTPkrroMKx/GLkawdW4wfS5s=;
        b=h0blL6qy0tb0VGu5enX6wXpsKbsUpeBm+uLPWufGfnvIBYe0ipk8GOzyeT0QbfuaSG
         QM+lIz5ON6kiw0AuHZKwHIPIb0LTzN2qULI/ifgkSWuxwdEYuP0FYiT1OiVvheSowAuV
         GE99uFTqqxLza0WnS8MJzxnMS/gqbMZG5hDUTaDdSl0LUx35Kn//jj+mhgur+8FcDoJ9
         15DnUti9MEBl8G2zyMvOyIWH5bDskbhfoHf9f9Fvh9bY+QCL08qIWG4GN0hgz3QYEoly
         fmzum0KwFsxxmeKE2smo6DQqHtm9drkRgj0PrpoQ7g54JI2RuKPuk0hVlS4/HjASokZ1
         1xXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731011207; x=1731616007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DaXja48Eoul2mL0v8OhTPkrroMKx/GLkawdW4wfS5s=;
        b=EpLg3l75enoiz7RvUQh7jZ9tLaD3OIz4AEduK0cnT672Kbfftki9uCCgoghkoC3lgH
         fDn22k9BddM18GadRjw9in/CW3WZWaMPI69OvpznBX3bFdPjGqSB4hopH2AFlBgPz2b0
         sAvbvv9J4Qv21wZwt64d5ZM0GUbiZ+u84asT+R+3xrCgWdjmNGFUX+jQH/5xWE3GgDeo
         KtGUK2OWl3d7N2NVqEosglAsmhoFVY3V3DcPyeTjyScr478P/Zfy6iacD0pQNeZ0Htnd
         KHZyOEPhIuJgMDkLOmS2+wvNJYzIVWo41jn8NDt+oC/MIYTod5nCLkESKdu8R9falabB
         1V0g==
X-Forwarded-Encrypted: i=1; AJvYcCVD12nTKD4cK9pluZ/G4ZgHavnUH5fVTWyndIibAoi9Id0P6kxOUoWo4anHFhj5zBUGYOog93I=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy2Y2ywLgEm4qanz8raZv0BTzHAXPrV2pPAkYBUTTE3GYGKmuK
	q2mW7kjPTb+DWagdPMo1OMQgqmPGa55o9ZLV2bUWjBw6F7tEfinyA5vMd8t7JwoKM4SieUEvK+h
	Zbg==
X-Google-Smtp-Source: AGHT+IFGnCavdqNWrqQzhvzEc2Nc4+MjfMOxSGbHqWn9yrACMcOtJh8NbYcCcVft7/QoNWhW/fUDme7cQ9Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:7307:b0:6ea:3c62:17c1 with SMTP id
 00721157ae682-6eaddd75f83mr31897b3.1.1731011207357; Thu, 07 Nov 2024 12:26:47
 -0800 (PST)
Date: Thu, 7 Nov 2024 12:26:45 -0800
In-Reply-To: <Zy0fPgwymCdBwLd_@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241107094000.70705-1-eric.auger@redhat.com> <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com> <Zy0QFhFsICeNt8kF@linux.dev>
 <Zy0bcM0m-N18gAZz@google.com> <Zy0fPgwymCdBwLd_@linux.dev>
Message-ID: <Zy0ihQlkexIWc1fq@google.com>
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, broonie@kernel.org, 
	maz@kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	joey.gouly@arm.com, shuah@kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 07, 2024, Oliver Upton wrote:
> On Thu, Nov 07, 2024 at 11:56:32AM -0800, Sean Christopherson wrote:
> > ---
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Thu, 7 Nov 2024 11:39:59 -0800
> > Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
> >  freeing VMs
> > 
> > When freeing a VM, don't call into KVM to manually remove each memslot,
> > simply cleanup and free any userspace assets associated with the memory
> > region.  KVM is ultimately responsible for ensuring kernel resources are
> > freed when the VM is destroyed, deleting memslots one-by-one is
> > unnecessarily slow, and unless a test is already leaking the VM fd, the
> > VM will be destroyed when kvm_vm_release() is called.
> > 
> > Not deleting KVM's memslot also allows cleaning up dead VMs without having
> > to care whether or not the to-be-freed VM is dead or alive.
> 
> Can you add a comment to kvm_vm_free() about why we want to avoid ioctls
> in that helper? It'd help discourage this situation from happening again
> in the future in the unlikely case someone wants to park an ioctl there.
> 
> > Reported-by: Eric Auger <eric.auger@redhat.com>
> > Reported-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> I'm assuming you want to take this, happy to grab it otherwise.

You take it.  Unless my git foo is off the rails, this is needs to go into 6.12,
along with a fix for the vGIC test.  That, and I already sent Paolo a pull request
for rc7; I don't want to overwork myself ;-)
