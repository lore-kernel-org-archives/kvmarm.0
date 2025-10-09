Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA5770830
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 21:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760044085; cv=none; b=In3jN/2Q+XiJancU/PQvmkrAyNwLfjX6A26jriHhY8GneSgwBvSbR8XqJk9i6UeOia8a/0uIuYNDUUsvcjUwI4We9dU552gXzqIWQvq2+qYfxyqXzQvmCEfjbbYqgXNAhpBJeh+ZQINBEPTYtbKB9I1Rh8Yv1KfXwvhlJJtnuhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760044085; c=relaxed/simple;
	bh=OV+I+IGp1YV8FAiM6+jyoDdlbVuoNoNGaY5rFMMy5Jo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FoufkpqYpTD2W4TWdyVM8jRueQ+J7ZkDolO2V6Dlxqx1ZLlkO02AQTW8/qwLejtKAHOVtZOLH/emm+2CfElFdHsGo4eaYMIVIkqLxL8TGoU59AI5Dt0c3nrQ1j8CHXn8b7Jxd2ej5k3M1yPe3H8x6dMVatdqOjda7n16XRAXgUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MJMoemOS; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MJMoemOS"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b632471eda1so2323789a12.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 14:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760044082; x=1760648882; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J8yL7yrEAZqRgLh743AzR/f5Z0OSynWI9v8HtFYQ07Y=;
        b=MJMoemOStbeKIFlDOYNOHCjav6OjvV6EUFRYNhPpFx50HUu6LO7vzhOEHtOJsgEp1L
         AxSok4BP+tHm6ozduphnfwmvSXxP7sv1TCj86bzroWuiTXuE1NfseEmB4yslU8B85lMx
         K6bhGFCq4k45P46OeshcApQdvYjgTnN5jeA0SqSGQy1jqSjO8hyGzcbyOuCRMJh6+Gk9
         ibIhoTVhSnnP/MQR0moyxK6LAZlP3f1NCc+8LDVXSeKDV3Vn/+JQESmTC+Csh2/nKCDR
         924/kvctDzG0DsgOOqaum9mKvAbeUi8CvfeSQJ2Q/916kFNjVMod+CZWlbrOIcXrDlP7
         +lNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760044082; x=1760648882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8yL7yrEAZqRgLh743AzR/f5Z0OSynWI9v8HtFYQ07Y=;
        b=nSgkfP6YdabYvIXohkBXk+fbWv80VsFlGmousNqNwznbfKqBU3s9jFKiBCGBU+S6kF
         C5CgcWK+C3jeWBr56s32gtEIfhU/Qd7OplfHt5Ozj1wOLOhgIMDf8qLUXZC7ujsxFLEL
         mevT4qA1epNkl9n3dvhTB8kJlBWY+M1le1+N31zPsOJWoI8U5xWZ8lc4IlQ4jh17E4mO
         6VWjRYzmvBC6xlDvPLsM5UlckhkUhz8Jywd2i3poxo678JUAnxRkO+JeJg5GCgH2Nc3E
         UABYhbvdFstC7gGl0g+01jK81cFshLnYoucqIZMaBwTVIViGTB1/NAb9h9wT4C3kPujW
         c+yw==
X-Forwarded-Encrypted: i=1; AJvYcCU5wZpqkgvwGdzRUSVJYRxOchFfz/UAmh3s2USR4KcJ60ayTCqSZ94IpNlZxqD5oDlvm5i7C2M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKMz7MckKzMcfXxZX/W94tVHbk8Wc4e7+A4GhKIbn9v9Ft22lP
	OEP6Q6dhqjNeaIYVsRFlPF1hBXeVvGpt4oHajwQ6L9q1ZNqVAGLPTYXsJG2t/0Y80YMXqYzNoWp
	wVhLhNfQFbKsQT4iH3sFYBjw61Q==
X-Google-Smtp-Source: AGHT+IFa7bhAUExVtejbjYxKsPiltNShSzZ9oTvDxsSQAjUcMKhU7xutFVMSZXzLhoi6fKx2krGDUJN50iFC9VUElg==
X-Received: from pjyu10.prod.google.com ([2002:a17:90a:e00a:b0:32b:50cb:b92f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b89:b0:32e:d599:1f66 with SMTP id 98e67ed59e1d1-33b513cedd3mr12577415a91.30.1760044082181;
 Thu, 09 Oct 2025 14:08:02 -0700 (PDT)
Date: Thu, 09 Oct 2025 14:08:00 -0700
In-Reply-To: <dd948073-0839-4f75-8cec-1f3041231ed7@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-2-seanjc@google.com>
 <dd948073-0839-4f75-8cec-1f3041231ed7@amd.com>
Message-ID: <diqz347riy1b.fsf@google.com>
Subject: Re: [PATCH v12 01/12] KVM: guest_memfd: Rename "struct kvm_gmem" to
 "struct gmem_file"
From: Ackerley Tng <ackerleytng@google.com>
To: "Garg, Shivank" <shivankg@amd.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

"Garg, Shivank" <shivankg@amd.com> writes:

> On 10/8/2025 3:44 AM, Sean Christopherson wrote:
>> 
>> [...snip...]
>> 
>> @@ -659,18 +667,18 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>>  					pgoff_t index, kvm_pfn_t *pfn,
>>  					bool *is_prepared, int *max_order)
>>  {
>> -	struct file *gmem_file = READ_ONCE(slot->gmem.file);
>> -	struct kvm_gmem *gmem = file->private_data;
>> +	struct file *slot_file = READ_ONCE(slot->gmem.file);
>> +	struct gmem_file *f = file->private_data;
> 			^^^
>>  	struct folio *folio;
>>  
>> -	if (file != gmem_file) {
>> -		WARN_ON_ONCE(gmem_file);
>> +	if (file != slot_file) {
>> +		WARN_ON_ONCE(slot_file);
>>  		return ERR_PTR(-EFAULT);
>>  	}
>>  
>> -	gmem = file->private_data;
>> -	if (xa_load(&gmem->bindings, index) != slot) {
>> -		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
>> +	f = file->private_data;
>
> This redundant initialization can be dropped.
>
> I sent a cleanup patch including this change a few weeks ago:

Agree, and probably good to opportunistically drop this line in this
patch than to combine cleanups in Shivank's other patch.

>
> https://lore.kernel.org/kvm/20250902080307.153171-2-shivankg@amd.com
>
> Could you please review it?
>
> Everything else looks good to me!
>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

>> +	if (xa_load(&f->bindings, index) != slot) {
>> +		WARN_ON_ONCE(xa_load(&f->bindings, index));
>>  		return ERR_PTR(-EIO);
>>  	}
>>  
>
> Thanks,
> Shivank
