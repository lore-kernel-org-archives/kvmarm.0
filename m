Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D72C49B203
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788354051; cv=none; b=LtPkiY2r7ioufRha5Bfj9hJIHeCUhpbsfgEo2Ium2Lkv1jsmb/XmNOFFV4kAH/O3iEFVzrp6vqtEc9vbEwmvjRCHyGc4xekryjKJgFaXFIzW9KCTZkSQ7cHDyz2RVQ9RaEFqc72NY2CvskAApbevgPylYsur5/is2SiBOmKM0Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788354051; c=relaxed/simple;
	bh=vMETqGmsLv+O1ZisrqmhUsbiFFXLQKrBrDQkabWILoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tmi7wyCGMDnD3VRGtDRtOWrD7wcAwja76Ih2FD677B/VNJihZA3nMY//WsckR5V++x7yDovp9b+0Z8BFLdPxkhL0viA/ieCoz/8ZGCAP4giA8l0wG11UJCkqK0EG59Jf0l/vi8jwOQaqZs3R9rsEUAZHgudbnO7V8g8tsjn1BmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bm316/ZQ; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bm316/ZQ"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso1601028a12.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 06:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788354050; x=1788958850; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VNGwYj2t4glIGNOen6FjZQq8vvtMMzT1HX41CF0kxhE=;
        b=Bm316/ZQZ6lajWzib5bi5A7hlvkVJaozpEAzDkwJOiJ8OOUGFn81QTTUr7wJ7Lq5Oz
         dm0FEjK7ykON9xyArsVQjURZ3AiX8Ss8rF2rya+WO9zFt4erCh3oiEcOi/4Ey0X2rwaz
         FmZ/h0Khl7DMmR7vLZeBDaE9WNk/ddXV+BTR6xbTSrLxADPPbChxzMUqThMSkVA1cxM+
         0eUiKkA+CKamrJsZSSXuwDgo5IGx0Au+BCZXVfYn8/m6AszGpae/L+zi5vSxFfh3Ts/U
         AQY0MZyf6zfrnnC8OIKRlwwjfg+m6LwHfJfbTn2Ri6GzXB+3EitlldgIjo9AuTrXwyv6
         4oVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788354050; x=1788958850;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VNGwYj2t4glIGNOen6FjZQq8vvtMMzT1HX41CF0kxhE=;
        b=qp2Tqt1u1ecfguA/EKc7T/XgyLaUs3uFDuyQ3VtCib1Qc0Bma1YZLYZIL26FPF5z/Z
         v2HjH6JPmlAZlGsKyPcsTSkUEXl9Mwn8FJdLBg8pQ9I7u2llm8Mqz9ydx0Gsd6PUvn0T
         wTDWHr7PKHmLYmDXuxazQCvTYfeesTGUlUc4NdH7Mi4etzkUyW0hHo5nxaEH/SE8N5Gm
         VAiUnqqh/rVBAAMrPO8BIlAkYr7W+LuX2qV05l2Jb9Jdl9ANSUwv7/PLO2De0T4Q44VY
         jf/c0HotAucj1tiWc6MdjILmT6jC4ZjxX0RUeN0vtTwYvl4WLdOri8G38EWji/Lz1qtl
         C3Iw==
X-Forwarded-Encrypted: i=1; AHgh+RpcP/3Eg1/E2HR2qbnNR5cnQoQEx1uJcIM7Iabke2yf+wruckwuNiVTx90CjvPmnPjhfNisbXM=@lists.linux.dev
X-Gm-Message-State: AFuF++lkiyegteqfMm6eQMBxnXBdH4BW6Pol9uFnt/DUJuZI59YS370g
	SDcIftlOwJGfk4HLHh+VkTWiymJfX6it2zAekQzEjkhSn1yHayHyxyb7HIVcwX4hMjWm6zKEKiT
	nyNb/dA==
X-Received: from pgdo11-n1.prod.google.com ([2002:a05:6a02:620b:10b0:cc1:5155:bdd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9151:b0:3d3:b02a:7252
 with SMTP id adf61e73a8af0-3d9b0f39b5emr5405095637.28.1788354049347; Wed, 02
 Sep 2026 06:00:49 -0700 (PDT)
Date: Wed, 2 Sep 2026 06:00:48 -0700
In-Reply-To: <20260902091351.438647-B-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-4-seiden@linux.ibm.com>
 <apdwHcdy2iYRTrww@google.com> <87ik4om4x2.wl-maz@kernel.org> <20260902091351.438647-B-seiden@linux.ibm.com>
Message-ID: <apgeAJKF--dZvKvF@google.com>
Subject: Re: [PATCH v7 03/23] KVM: Allow KVM implementations to switch off
 MMIO independent of Kconfig
From: Sean Christopherson <seanjc@google.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 02, 2026, Steffen Eiden wrote:
> On Wed, Sep 02, 2026 at 09:30:17AM +0100, Marc Zyngier wrote:
> > On Wed, 02 Sep 2026 01:38:53 +0100,
> > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Mon, Aug 31, 2026, Steffen Eiden wrote:
> > > > Only defining KVM_MMIO is not flexible enough for multi-KVM systems
> > > > where one KVM implements MMIO but others do not. Solve this by
> > > > additionally testing for the non-existence of KVM_NO_MMIO before
> > > > including MMIO code to KVM.
> > > 
> > > Ewwwww.  IIUC, s390 ends up with two KVM modules, i.e. there really are two different
> > > KVMs being built.  Rather than have a KVM_MMIO and NO_KVM_MMIO, I vote very
> > > strongly to drop CONFIG_KVM_MMIO entirely and replace it with __KVM_HAVE_ARCH_MMIO,
> > > a la __KVM_HAVE_ARCH_VM_FREE and others.  Tracking two separate macros is going
> > > to be annoying to maintain, and will definitely be confusing for non-s390 people.
> > > 
> > > It'll mean linking in an emtpy coalesced_mmio.o on s390 when building without arm64
> > > support, but I'm guessing that won't be at all common for s390 builds.
> > > 
> > 
> > I ended-up doing something very similar locally, because I couldn't
> > really make head or tail of the logic while being in holiday mode
> > (which doesn't help). However, I kept the negative logic, so that we
> > don't need to add anything to any architecture but S390 (they are the
> > odd one out here).
> negative makes sense. 

Ya, an opt-out for s390 works for me.

> IIRC KVM/power does select KVM_MMIO most of the times but not always.
> I'll check that.

Huh, indeed.  KVM_BOOK3S_64_HV=y && KVM_BOOK3S_64_PR=n ends up with KVM_MMIO=n.
Though I'm not surprised given the multitude of variants PPC has.
