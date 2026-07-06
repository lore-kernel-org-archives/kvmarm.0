Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C5A47ECCC
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 21:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783374205; cv=none; b=Qn0FHVLF0NBZ0MA+WD8PiTUuVmmTzh1XA24ZMT9uBzmyEWYjAa1eKCRTljhEOjqMwrrvtVXJJ8IvCmNUzC47mSq7v8qjm1QmOBtWBgan1Wn+5OFQlPUChhQ+Kj8LWGpVqCWDD1ZxKlTDbVecg5K2f+ozsUkKHTPJ4U/HTHrdcwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783374205; c=relaxed/simple;
	bh=OAQhr3waP5J5O1KHcN/lUO1tFTqTArndt3VJbZ8eN/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EYgsR9dQxARC1hwL9yr7y2Hv9EcYCtYLXNA/N2xHK5bkTr3b9U1PIS7BCoxcSYpp2Xe6wIoFo4wADxCr+SVuDgGq03qfHgFWSIwPFrWVgJa0pqA6mUM++ytOomTee7noMKQ5UmUSPrF4mJVCv2kcC844Q6djHcdnZKkZv+8Ts7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZDLSj5rX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZDLSj5rX"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8482b95574dso236520b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 14:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783374204; x=1783979004; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oafaChChcAwJSOuf1i0h67RyVsfw8NcuMZenVaI95Rk=;
        b=ZDLSj5rXN8VVD76G09BE32TfI5Ki6iWMF6LxD/Cx/Pc/0lLecgoifPBn66Icnfequj
         mbrgP7T1qIPev2m40XVsrwOKHhNPO3hctT5y1sbBAStDzSoje6tWBXwFKRr+Cnl45oAE
         xfnc+aNKxVo1xoqTsYR6kjMcfUHZMqGhGtKMzQ1p/5gYEUkarMAruTFgm2dfyvWoCX2z
         K1K0k/FRIOvc0rRGYZaF3jNax30xDO1UbgpPQCHlFKt37GKu7uZc8x6eIOq80fj/ZG37
         WmsEq7ZCYYTVtI6Cqn5PUrhc5MqtyRyINjJhJcZaMNU07mMRa3svHi7sU9C2p2dTXFnQ
         Yj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783374204; x=1783979004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oafaChChcAwJSOuf1i0h67RyVsfw8NcuMZenVaI95Rk=;
        b=RkkFu2txxJJT3qd25Zdn6qVvOLo9+azDhiQWMdAUBsoeebX4DMe6n81k073111RFCn
         BB50r6jeMbxOhi4TeKsffDrlYCAJLUKQwUpKFtDYvsQo4axxA0IVqIWkZbuBi0azXZwD
         D4L54SVNyw6+sFRMKCox0qgPQAXzHp6t0zLZF1KWAd6G4v/PuRDkqwxW+6mlm2HVY2G7
         x9mDzU1PPckYE63Ki0yiRQdrro5j2oJQfvg6MfN515ez7m2saAfFQfZX10OCysV7bL3H
         usYGkN0DVwCKaFn9R/B7t+dKcIfUet1GMuV9KssWF22+Fe9fpbqyLjNCg+xuJbHQZhZa
         /0WA==
X-Forwarded-Encrypted: i=1; AHgh+RqqfJTleUFNgv556m8JIfRbe7AWb+DROCMG84HIYPnWOD7qCh2Crd4P0udgXNQ+UJ5wQ5xwFew=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz36NHzjMhyb5BPGQrC/PnUhjRm89cAdj8/LXRAhSZogxWuKZ2Z
	5sfBfpAuER1M2x45EuTlxaru4QAjbzBbN3h2ZxI9IO/vvnFHp1lmeTFF7/GBiVTW5vKVQQUsbsL
	PVi8wSA==
X-Received: from pgwa11.prod.google.com ([2002:a65:654b:0:b0:c99:d21a:f6cc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a383:b0:3bf:d1f9:b1d5
 with SMTP id adf61e73a8af0-3c08efad6fcmr2613875637.60.1783374203865; Mon, 06
 Jul 2026 14:43:23 -0700 (PDT)
Date: Mon, 6 Jul 2026 14:43:23 -0700
In-Reply-To: <20260702142912.6395-2-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702142912.6395-1-alexandru.elisei@arm.com> <20260702142912.6395-2-alexandru.elisei@arm.com>
Message-ID: <akwhexqW66RK5Gru@google.com>
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track of
 associated memslots
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, david.hildenbrand@arm.com, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev, mark.rutland@arm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> To enable memslot operations, KVM maintains two arrays of memslots, and an
> RCU pointer to the active (in use) array. Changes are made first to the
> inactive array, and the RCU pointer is updated to point to the inactive
> array, which becomes active.
> 
> The guest_memfd file maintains an xarray of pointers to memslots that use
> it as the memory provider. After the RCU pointer to the active memslots is
> updated and until SRCU is synchronized, readers can observe the old or the
> new value for the active array, and therefore the old or the new pointer
> for a given memslot.  For memslot creation or deletion that is not an issue
> for guest_memfd, as readers will either read the same memslot pointer saved
> by the guest_memfd file, or a non-existing memslot.
> 
> But when changing the flags for a memslot, readers can read two different
> and non-NULL memslot pointers. 

And?  Why does that matter?  KVM memslot updates aren't atomic.  Practically
speaking, they _can't_ be made atomic.  Userspace is required to quiesce all
activity that must not observe inconsistent state, i.e. userspace must pause
(stop running) vCPUs when performing a memslot update.

> Since there is no easy way to ensure that the memslot pointer that the
> guest_memfd stores is consistent with both views at the same time, modify how
> the guest_memfd file keeps track of the associated memslots: instead of
> storing the pointer directly, store the memslot id and address space id
> (as_id), and use that to reach the memslot in the active list of memslots.

I don't see how this changes anything.  Readers can still see the old or new
memslot depending on when kvm->memslots[] is derefenced.
