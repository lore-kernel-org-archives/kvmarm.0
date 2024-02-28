Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE90879B74
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 19:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709147636; cv=none; b=rwQGXntd5VsAHbTq+AQxADorNLSy4o7hciYlUGTZliKRxfhx48WIDY3dmN/2aFDyJSdDo9s5ctaOxEU2OnaYbE1qem+1Wm9Yqmhj438Xhj6ulK9ZUsIciFCSAkiKQzKazu1s9cYR0FVeIN+1g8AB7iygwAYt6Sm0PyWR80i8PE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709147636; c=relaxed/simple;
	bh=aPHfE+xG63cM4aPmBMQYlD88eNb+qx1qroapVlkQIoE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=miF7vbn9riPJIZzPAM8UG9klHONefaoxPY5zAtEZbQWto9aKeI0DkdGfWuBiFHlgUJOZLttBFBaplzh6hTXWGNmsiHFa1f7G8nSseUeZA7wZTxVn95cgGQ7tNoM0oJVYXL0L5teujJTfqotDQ/f/CqjvvqwA2KWlrdasMgPOI6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2GXrtW9V; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2GXrtW9V"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so44609a12.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 11:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709147634; x=1709752434; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uz4eD++cwFSaXESa8xATo1F9JmG4DxJ2Fd67SlMVBTM=;
        b=2GXrtW9VtakBFKik1yZYWWzwV56kTvjX6hoS1CQHdqzfWxyqGNI22JVT8DftxhQ4Az
         5yq6k+q1id/H5Y7OIGvxpxzmUKlttoUmk5h+PfZslhZYSWWEB8IbpTBauOxNfZNnwrL8
         DZLVUuCKZrfHr55ioMKCptP87KdZhxl6NHKrt5WmbaE9+Pdr/kjqZCL0YtLg5SLGwybr
         URTJjL7FlWJGlhAe7gjMAWQULAbKKf/kM3fNu7ahPOI7VjhDsVHAaz/LCV9gF9uRNZwd
         BCjJqtl8hW5MU2Xe5pYSPjet8iT2UH7Eun0KCGgeQFO9OMKkfiJsbMFnKMqW4aFsKfb7
         1Aog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709147634; x=1709752434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uz4eD++cwFSaXESa8xATo1F9JmG4DxJ2Fd67SlMVBTM=;
        b=Uyqwwai/6zBdm9TyICWWCYVQA8AplTlk4w5Uv/UsycMDwemQopP6A8HwGDonDiR/R1
         nMLwGWuUi3G0os35jzN8vBiFiYEeDV5rkIELhuLvzQsHLKXcM9yrWQSyWv41w+/3N4D5
         Hmlv5KORujDAn4+VNPFlbXj/CS/6lDNzBfc7CPxlvh3MTtF1t1w5ymZXRcz/6CN91mI0
         Qpr2fBaPP+i2GAL1bZQ16SQAiB7+hsqEpebB4tLNEJoiZ8q9izVZALLCB9wX8Rec2DGH
         rzd7yuPtFhQYJdPpq1yeuYgi0xv/f/TaHRk1qVFsLX1pteaeliIwyYLEob+7esIzQcuO
         sopQ==
X-Gm-Message-State: AOJu0Yx4U6OFysCugM8QX4O7R+iQ1bynN6YA7yvHPFz/yLJObQnnzHLB
	SktoQYMUeVtPhwth6DyKvp3IEbEWM2LyOUQs3BI5d4FlDPaBUCMaRmNM68evq94MGvKcFtF+DL0
	lwA==
X-Google-Smtp-Source: AGHT+IG5wxr92JAxQ6mliFe+EmUX49TYqsY8AnsNLAM9Q+bhoAp73jiPNNcK0kJtVerB+KypcWF7hxT6QdM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d99:0:b0:5ca:3387:5fbb with SMTP id
 bc25-20020a656d99000000b005ca33875fbbmr1115pgb.5.1709147633815; Wed, 28 Feb
 2024 11:13:53 -0800 (PST)
Date: Wed, 28 Feb 2024 11:13:52 -0800
In-Reply-To: <Zd92fobEy4HFOb24@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
 <20240227224249.2209194-2-oliver.upton@linux.dev> <Zd9q5KbkLnh5Wddf@google.com>
 <Zd92fobEy4HFOb24@linux.dev>
Message-ID: <Zd-F8F9OTehNoQiq@google.com>
Subject: Re: [PATCH 01/20] KVM: Treat the device list as an rculist
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 28, 2024, Oliver Upton wrote:
> On Wed, Feb 28, 2024 at 09:18:28AM -0800, Sean Christopherson wrote:
> > On Tue, Feb 27, 2024, Oliver Upton wrote:
> > > A subsequent change to KVM/arm64 will necessitate walking the device
> > > list outside of the kvm->lock. Prepare by converting to an rculist.
> > > Note that this has zero effect the destruction path, as every reader
> > > should be protected by a valid reference on the KVM struct.
> > 
> > This should leave the destruction path alone then.  Simply using list_del_rcu()
> > doesn't convert this to an rculist, you need to actually synchronize against RCU
> > for this to have any meaning/protection.
> 
> Did anything about this diff give you the impression this wasn't
> thoroughly understood?

I'm taking exception to the "Prepare by converting to an rculist." statement.
This is not an RCU-protected list, it's a list that abuses rcu_list_add() and
list_for_each_rcu() to allow readers to run concurrently with insertion.  E.g.
IIUC, if it weren't for PROVE_RCU, the rcu_read_(un)lock() in the reader could
be omitted and everything would work just fine.

Ah, but it's a moot point, because kvm_device_release() does delete from the list,
and does not do so in an RCU-safe manner.  So that needs to be fixed, and then
this is indeed an RCU-protected list.

  static int kvm_device_release(struct inode *inode, struct file *filp)
  {
	struct kvm_device *dev = filp->private_data;
	struct kvm *kvm = dev->kvm;

	if (dev->ops->release) {
		mutex_lock(&kvm->lock);
		list_del(&dev->vm_node);
		dev->ops->release(dev);
		mutex_unlock(&kvm->lock);
	}

	kvm_put_kvm(kvm);
	return 0;
  }

> > The above alludes to this, and the
> > comment in kvm_destroy_devices() helps a little, but the code itself is actively
> > misleading.
> 
> Which is what comments are for. I deliberately chose to use a consistent
> programming model (albeit unnecessary to anyone who actually understands
> how this works) with the hope that _if_ someone comes along and needs to
> delete from the list later on they consider the requirements of RCU
> protection.

Ya, I see where you're coming from.

> list_del() or list_del_rcu() will fail in an equally-miserable manner if
> the previously stated expectation of readers is violated. Poisoning the
> forward pointer would be nice from a debugging POV, but readers could
> still hit a use-after-free.

My primary concern is not what happens on failure, I'm concerned about misleading
readers by implying that this is a proper RCU-protected list.  But as above, that's
a moot point.

As far as the failure mode, my preference is to poison the forward pointer.  It's
not just debug friendly; hitting a fault (#GP on x86) is a "safer" failure mode
than UAF, e.g. UAF could result in data corruption if the freed memory is
re-allocated before the rogue write happens.

> > I don't know how I feel about using list_add_rcu() in combination with list_del(),
> > but I like it a lot better than using list_del_rcu() in a way that is blatantly
> > wrong.
> > 
> > So if we don't have a better option, I would much rather do only the list_add_rcu(),
> > and add a comment _there_ explaining why KVM inserts with RCU protection, but
> > frees using regular ol' list_del().
> 
> Describing our destruction rules on the insertion path?

I was advocating we document the insertion rules.  The destruction rules for devices
aren't novel, they follow all of KVM's existing rules for destroying a VM. 

But again, moot point, because I was looking at this from the perspetive of a
list that isn't truly RCU-protected.  With this being a true RCU-protected list,
I agree that adding a comment to the insertion path would be redundant/unnecessary.

> I feel like that borders on contempt for the reader.

IMO, RCU is one of the most difficult things to use _safely_.  (Ab)Using RCU in
a way that _looks_ unsafe is setting people up to fail.

Bug once again, moot point :-)

> I'm happy to leave list_del() as-is but I'm going to insist on documenting
> destructor behavior in the destructor.

Ya.
