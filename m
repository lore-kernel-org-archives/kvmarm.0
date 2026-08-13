Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD436A033
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 23:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786663979; cv=none; b=IQy9bXxFbyuLFGkom59ishVCmy2YKD077HAz6236jwLg0M4OeghfjAT3cJlN5PlzcQID9ZiVviuoCm+4IGItEX+wUKiYcDzBPkJM87UTSHpPpaB6iarmHJTFJHE9rJs4wsN8t/4thjH3N4auBcd0UUMWv+nycGSpNpcAN8XqPVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786663979; c=relaxed/simple;
	bh=OA5h+aV+ThA7Ai5qz/1Lb2Sur7kTcoij03QdezWTZcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c3p0MNTreEsap/98zAtvHOHcdqz72C7jGAxEZrsvBTogRKtmtYCfdo7Fm0JB7Tec5Am0zNWzdmmUP/USRwXfIqcOpWZpXVSHQqNDgEDUjZR6+UVAVYQgA5XjQKSKP38IVdeghEkeUvAbK9fyVsBVadSEpu1tp2Iw7oJvDOUbPpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yp2WipM5; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yp2WipM5"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84a3514f912so495593b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 16:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786663977; x=1787268777; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nfsw3dCbG2eROZ65PkHFv78AeM3AjkoQEz/YIwe6msI=;
        b=Yp2WipM5zTN6l1vlp8KUCuSmYiwu3uqyrDpuayc4M1Lj93A3+rKYdPX9QyWbXLLAWX
         NaY4/iMcL371KSpmIS5nHLo4fHJ886Ef2oaO0dRh8JgysPbgns0WsTP/15aRLgv91u/U
         wjA20Xm0HE3zegaGjdBvgaXf+Wl09C+OZcVF1XzLQ1kiSrh37WQy7ue4g1kffGhan5/a
         teC+8aMMC5+CH4h0a/ScOxxYoACFVVCPbqX39psDYyzMFyeYp403WUIDru7t4N2SCGNA
         iv0OTDT+18s3YJM/O/eoDNxGJJ/vNCXgfkz8W5WoOz0B9gnFML6rqhHTnM24Aux0Yr8o
         U/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786663977; x=1787268777;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nfsw3dCbG2eROZ65PkHFv78AeM3AjkoQEz/YIwe6msI=;
        b=MqePqUrHbMMXR8hxBcfjVhy4RBmmxEvUMIwfh4LAJxdslMSq4MoqcyDGcap7GBZniI
         KCcPE5MpqD+LGZuJ6J+JAkZunzU4MBw1YbjblgEbQNMZxW2kRuYzWVkejnbEmo2W9EAM
         Pe4HSNIerZuscPQfZLi0LeXpGLyw7cYmNjQYOQs6uLQ/iC0Obs8BzOqqh3UDdWXgJkU4
         ZeIwcdkDZNJHNABK4qEZsKY8IDJloVibESKVTURNTVtlhju0+V/bzg23MLNzB601DWJ0
         d3EoDH+nO7hn68WRjVhSoV+9WJkM+SCWYBkpEd23YCGkNF9LSRDkdf2DJ4P2Ivd9vUH1
         8h1w==
X-Forwarded-Encrypted: i=1; AHgh+RqLQiNN2RKnAlVI1GhAEVMD3kFMawR4hzhzeLZGoTyXqI8cv6gKwUJxXTdzDtiYQLzHlJQ5Qwo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3NrBHAnAtC3VuuZj4Yj0dsQ+4XXI0ul8xtixkRPNYB45d7UPO
	vx7O2NAnC0E7caLi6mq+eC4eq/9obVef3WS8Ur1oERsUPjjC64Od1A1MhEY3ivAUev1un8FvBNL
	E8MY4Ew==
X-Received: from pgch28.prod.google.com ([2002:a05:6a02:509c:b0:c9a:ffcc:19c8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ab0b:b0:845:ebbf:e7be
 with SMTP id d2e1a72fcca58-84fde2c543amr1679491b3a.23.1786663976531; Thu, 13
 Aug 2026 16:32:56 -0700 (PDT)
Date: Thu, 13 Aug 2026 16:32:55 -0700
In-Reply-To: <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com> <ak0wSQ1133O7B96D@raptor> <ak0ziUcCXUlDdcla@google.com>
 <ak-EKSslAz1uqEtv@J2N7QTR9R3> <ak_wC4Q-mQe14DI8@google.com>
 <alDI1b8fC99SG4_a@J2N7QTR9R3> <a127176a-1722-460c-aa84-754e1d343f53@arm.com>
 <an3sEiQlIuGEjUur@raptor> <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com>
Message-ID: <an5UJ4S_P1LUFmzD@google.com>
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david.hildenbrand@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Mark Rutland <mark.rutland@arm.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 13, 2026, David Hildenbrand wrote:
> On 8/13/26 18:09, Alexandru Elisei wrote:
> > On Mon, Jul 13, 2026 at 04:11:57PM +0200, David Hildenbrand wrote:
> >>> Yeah. I agree (with the caveats you mention). Arm folk need to go figure
> >>> out if it's worthwhile to support with all those caveats.
> >>
> >> Right, disabling migration (once gmem supports it) was also what I discussed
> >> with Alexandru when that topic comes up.
> >>
> >> How to communicate to gmem that it wants these fixed mappings is a good question.
> > 
> > There's already a proposal for how to do this in the migratable guest_memfd
> > series [1] - it's a new guest_memfd creation flag that disables migration.
> 
> In the guest_memfd call I was arguing against the flag in the first version, and
> instead adding it when actually required.

Ya, right now a flag is meaningless.  Telling guest_memfd not to do something it
doesn't ever do...

> I was also raising whether KVM couldn't tell guest_memfd (e.g., at creation
> time?) that it supports a CPU feature that requires S2 to be always mapped to
> disable migration.
> 
> It would then be a contract between KVM and guest_memfd without user space
> having to be involved on that level.
> 
> > With Sean's comment that he expects swap/reclaim to be fully userspace
> > driven, I believe that would be enough to guarantee on the _kernel_ side
> > that SPE will work as intended for a guest.
> 
> That's my understanding.
> 
> > 
> > I'm a slightly concerned though that all of this will work by chance, and
> > not by design, and in the future the behaviour might change to allow
> > guest_memfd memory to be unmapped from stage 2 without the VMM or KVM
> > explicitly allowing it or initiating it.

Meh, TDX on x86 already has the same requirement.  Unmapping a page from the S-EPT
kills the VM unless the VM was expecting the page to be lost. 

> Thus my idea of the explicit contract between KVM and guest_memfd. Instead of
> being a "this doesn't support migration" it would be a "S2 always mapped"
> kind-of contract.

Who would that contract be between though?  KVM can tell a guest_memfd instance
that page migration is/isn't supported, but telling guest_memfd that the VM will
always keep the entirety of the guest_memfd mapped in stage-2 is nonsensical.
guest_memfd simply doesn't care if the page is mapped or not, it only cares if
migration is supported.

> > My understanding from the conversation so far is that the plan for the
> > future of guest_memfd is to support an option/mode where the memory is
> > effectively "pinned" at stage 2 (but which allows userspace to explicitly
> > free/unmap it, of course). Is that correct, or am I being overly optimistic
> > in my interpretation?
> 
> We could then even disallow fallocate() to punch holes if that contract is
> negotiated.

Why?  If userspace pulls a stupid and kills its guest, that's userspace's problem.

KVM would also have to block memslot changes, and probably other things in the
future that would unmap stage-2 in response to userspace syscalls/ioctls.
