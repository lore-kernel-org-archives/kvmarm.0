Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AF23DDDCC
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 13:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786367334; cv=none; b=ZrsW033aobNVphLeJ/4uvGS2p1TFcbp3v0zixglfg9bzWaDzVxtOlZRgT7qM0HRfnL+bUzJPxYx7C354xsSogweJ0bCAc5wxfFX/1AnIwnlgnRX5kC8RbPnC2ki//tB4WpNoayRqDHJoCvO3qHvV6BFZ31yB17A48a3JzeieSYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786367334; c=relaxed/simple;
	bh=vBxAOqpXOy3xBw2jLlc1xHZGLUnTc7rwy+EMZmi2RU4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bBOEUB7mxguOHNGTcRMAj7iOT3rRjRrpvdmUvvHGN6BK8+ifVTunsu1RlGQB67Wc8Icxb/lupzbdg+8vuRYqyBgunNSwTLJz/A2KHJkImVfuC1rAkxXwsTPYNqRPxz13eSBYRXoNFsMqiFVXXVdGpzgrvNhP978bTx9jTNWDPRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jNUn4f8/; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jNUn4f8/"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a22bf0so1888263a12.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 06:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786367331; x=1786972131; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oMcbMXyReyKJIZVlqYCZytsphgwWMjfKxVFVMEfDD0k=;
        b=jNUn4f8/1j3DaYBM/ASlzmW46sDZGVrCRFJPFoH46nKVRMlrdj5MgDNe2pP+i2JHOd
         ivkxnxu6McDjvAaz9v4y4fxUaisVQLp5gjcG82gtvcr8GrQ2M+BzypBWiRQKumFAbJnL
         j+zDwEHBJO/rc+jYieHr3scYpLKVbYTZ1hB9u6x85hrUdRJMSpKL5kl+gTVEjVFo+CUj
         aHwgfiR2bauuFda7VNB6hE3RIWp97Wm/v3chlytlzWXdF5ucKaeMOfzLnbEG5MqXpNX/
         HZyp9ZkECyWvYjua1nr8aKwcn8LeGP1KGPAcXd2W5DnddGOlpSajZWfcS/Z0nMY1JhNd
         FGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786367331; x=1786972131;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oMcbMXyReyKJIZVlqYCZytsphgwWMjfKxVFVMEfDD0k=;
        b=qLauvhWIR0G+J5Ve4lTzMJd6TYhYs/LwrFiVbZgTadkcYTJFuBVKN/A6LoK09EqXdf
         SsComov9kBmMkRfCDQtzSBwhHLVMc5sc0W1pg7Y/VVROHeu0QPhUM/G6PbrvEemIoGw1
         cOFvIN0ilH8L9fggdTHQWAXebcKQf4yUhKkEMPRASKA2ww4J2frOnSWUG0xzwvf5Bpbh
         oxyG+gYIgmUmE9MiYdBpZykmSSeNcux4Eu1wzaEeO2FGXxEy7r+VVvlBtSQkOktWgtxJ
         Mw3l1dB7xhXjghoSK6okcw3pHxT0/ZSqOmDnVaByiDqW5moHw068egjjcRmzIszAPMB0
         NmEg==
X-Forwarded-Encrypted: i=1; AHgh+Ro9z8hP5JIsjQjfS8GTGaBFnkJVZSjlZlsAw5iZptq3RfpjCCmnNNQrIESgJB+bZTJ3qEGwkgA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwofPkxrJfX6qB375H1ySSMDUVjse9s+R4p0TJA8FpX7Df92C3B
	MOa4GCMl1tnyagnmTxX+4W8vMiZt9FBHxvIw2YqwjvLdIiNqAQJvBoBHogln21S1yIxD0lvE/TZ
	r0OJ/6g5/WqrQiQXKMQ==
X-Received: from edbek14.prod.google.com ([2002:a05:6402:370e:b0:69f:da3d:dc37])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5048:b0:69a:a4cb:2882 with SMTP id 4fb4d7f45d1cf-6a355db411emr1046692a12.9.1786367331218;
 Mon, 10 Aug 2026 06:08:51 -0700 (PDT)
Date: Mon, 10 Aug 2026 13:08:50 +0000
In-Reply-To: <CAEvNRgHW0P78eL0ip799XF+2geKwz7MQrjSFTgvCdUAuh9oykg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-8-tarunsahu@google.com> <CAEvNRgHW0P78eL0ip799XF+2geKwz7MQrjSFTgvCdUAuh9oykg@mail.gmail.com>
Message-ID: <9huz7bly86n1.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>>
>> [...snip...]
>>
>> @@ -273,16 +284,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>  			       loff_t len)
>>  {
>> +	struct inode *inode = file_inode(file);
>>  	int ret;
>> +	int idx;
>>
>> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
>> -		return -EOPNOTSUPP;
>> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
>> +	if (kvm_gmem_is_frozen(inode)) {
>> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>> +		return -EPERM;
>> +	}
>>
>> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> -		return -EOPNOTSUPP;
>> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
>> +		ret = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>>
>> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
>> -		return -EINVAL;
>> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
>> +		ret = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>> +
>> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>>
>
> Continuing from [1], this guard is actually meant for PUNCH_HOLE... I
> wonder if there could be a deeper refactoring to check when actually
> punching a hole, basically the equivalent place as kvm_gmem_get_folio()
> in the flow of fallocating.
>
> Will srcu_read_lock() be taken in a nested way for the fallocate case?
> It can be taken in a nested way with some intricacies, but maybe if the
> freeze check can be done just as the folio is about to be removed (as
> described in the above paragraph), it would avoid this nested locking
> here.
>
> [1] https://lore.kernel.org/all/2vxzzf0kl3dt.fsf@kernel.org/

Instead of avoiding on remove folio, We can just add the freeze check
across the PUNCH_HOLE, So there will be no nested lock anymore. Nested
lock is just with fallocate populate -> kvm_gmem_get_pfn. So this nested
ness will be removed with this update.

~Tarun

>
>>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>>  		ret = kvm_gmem_punch_hole(file_inode(file), offset, len);
>> @@ -291,6 +316,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>
>>  	if (!ret)
>>  		file_modified(file);
>> +
>> +out:
>> +	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>>  	return ret;
>>  }
>>
>>
>> [...snip...]
>>
