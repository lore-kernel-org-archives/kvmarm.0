Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CAF191F91
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750296438; cv=none; b=BvJc/Lxlxn1MX2VX2+YNecg2UH+kv8Nl5MN7MMh4IWOdY0YOy2W7VCO0DCEDvCFz+uqYYrVlB0rC7srRlQlpFDuWvu7v31vaOm0PffzQa5/0vD0N1nLtxTiamEbfdKcPQb/Siriz20RCitVvIUZWxtCyU8R7T1hmjxfLhn069vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750296438; c=relaxed/simple;
	bh=vm4zc61kQIKBtTJCoGSRV55SShr3qfwIna2hrOexzxU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lUiSBZAGeayQeil4X6St7juNYCM9au0y4+GGQF+L8Hw3ZjtetPHnQi0UhW7Hq6AsVh9xi2mUc+dHRqigOxKGqiwZGvkz12B7xi59FBHe+C7Z2L9iVL9rIbW2kxs/EdnhGJCw5I9a14qf3Ki90PPG9IoIkFJ+LMkFZ183pVdWmcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3trieZPs; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3trieZPs"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31831b0335so404310a12.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 18:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750296437; x=1750901237; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFJAbnmipeJwNloKOstVWAEzz4JfWsiupTDJwINriZo=;
        b=3trieZPs02tNxa3t+35+BaN02SLURG/1H8Kzmz+5AzH+qiwByqcb0rXApYfnbJZlYs
         QJ7P8h0jYWrkkun99YApxLvGJeN2jMHtz5G4IHJS9Ibi6yNyNgLVxOX7jl7NQLCZHoQ0
         wQZS/m9dU7G9s7/LcRgKrnms2ib6lXmqkIa3fsVMQcSN8kfwlHrCF4V6eIuuoH1McQQn
         lFRTqOkiyoWh/BCsJmhnNfayutuU24mGl9ldL+q7FEbGhfI6vCD59EjdrWrOMMhRVrs7
         6qo1q/BtGr+p4LgzIU2tAL1n/Qc2GknAPn7zv+gmNzzNWLcUBa6PAUO4bEdjPCpfBZmR
         sqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750296437; x=1750901237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFJAbnmipeJwNloKOstVWAEzz4JfWsiupTDJwINriZo=;
        b=d0LROTPBYyxW8b4xKmwkeadcIcSGk4OuiUrCVVBpNeWEZV7TRDZ6XpYc7Pej0MAVM2
         9ZFF97LuztdHquy3qK5IsfrR8fDnTV35V25VXVFsGnhagxgqAnZRG0jGiNIRmhnBX5t1
         WeaqkZ+Ok14KRHFWycc7K9bYNs/KfMjIgopb2HoKC2zNCOYcgaabO466++TlieSNXvUz
         qM1NUfC761DBp4Su2Tj14l+N7qWRbgF4tFl2zFGU73pb9I7BgzJ6RkDtb3AjqrSnFyr6
         fYKkmK34zHM5GGQLJa/sFVJTE8wh9ms+Dw92WrEaWfUJhnIn8ms3pxAzhqpE6iXXXygL
         eXYg==
X-Forwarded-Encrypted: i=1; AJvYcCVZU/AkhpC469b2zzx+pmQHoe7rRG2EWc9F0MY3NlV6yR920kHL885FmlvzpIoErU8Z+Z+kPmM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiPYwHfQh2sxYt8c3jds5/L6sIB9i/z10UlkIfE17JBtb+1ABj
	sHy7QWBTzWW4AKF7G4w7bvm47y9USDPA1k+60hd2NE75jWl6roA+gB8JvbljRxNHlADjSsQGrSQ
	v7fvGnA==
X-Google-Smtp-Source: AGHT+IHfYw3saIGenxdx6hofcNW6m39z+U7j5TjuceZidjPioll6tGDxZ6q1q2NRMsSKefNry3vZpYE+zns=
X-Received: from pgnr29.prod.google.com ([2002:a63:8f5d:0:b0:b1f:dd75:de2a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1ac4:b0:234:9fea:ec5f
 with SMTP id d9443c01a7336-2366afd3a91mr304909275ad.1.1750296436711; Wed, 18
 Jun 2025 18:27:16 -0700 (PDT)
Date: Wed, 18 Jun 2025 18:27:15 -0700
In-Reply-To: <aFNBCaLEdABfybmd@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-5-jthoughton@google.com> <aFMWQ5_zMXGTCE98@linux.dev>
 <aFMh51vXbTNCf9mv@google.com> <aFNBCaLEdABfybmd@linux.dev>
Message-ID: <aFNnc1hZEWcU0Nh_@google.com>
Subject: Re: [PATCH v3 04/15] KVM: Add common infrastructure for KVM Userfaults
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 18, 2025, Oliver Upton wrote:
> On Wed, Jun 18, 2025 at 01:33:17PM -0700, Sean Christopherson wrote:
> > On Wed, Jun 18, 2025, Oliver Upton wrote:
> > And this path is other motiviation for returning a boolean.  To me, return "success"
> > when a uaccess fails looks all kinds of wrong:
> > 
> > 	if (__get_user(chunk, user_chunk))
> > 		return 0;
> 
> Yeah, that's gross. Although I would imagine we want to express
> "failure" here, game over, out to userspace for resolution. So maybe:
> 
> 	if (__get_user(chunk, user_chunk))
> 		return -EFAULT;

I toyed with that idea too, but if kvm_do_userfault() returns a value, that it
bugs me to no end that the callers blindly convert all failures to -EFAULT.  To
avoid that, callers would have to be:

	r = kvm_do_userfault(vcpu, &fault);
	if (r)
		return r;

And that just annoyed me. :-)  But I'm a-ok with that direction if that's
preferrable to the boolean return.
