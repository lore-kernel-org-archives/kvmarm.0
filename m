Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3344A94A
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753950583; cv=none; b=B1UriFtr2egwyAMqHxrst0J9aaaHsQlFxta+TTIaWfVy3o5mCtYScZdocIlF4vQsMftIJZ00JFDk/dDNuing3Ej1frt+UZCci9WonMY2cmVA9MyDm3L3ll64Eem9JSq7iW3J7+3F4zhnYNrm0Sj84++gw/88fBjmC06RdQSXyao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753950583; c=relaxed/simple;
	bh=AMsJabH4uTEQwdU7p1aCd3u4s3N0oQl/CFz7UNeKcEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWpL5Gkff8A90IgjEbAVHO1qoZyQp9r/C9BHxqV5AAL6AkOyaZADEk8+pVnC6B9XMfq6oKvC4Tw8igVGVzfhfkHizc7RDIui7M7o10+fMwrNO5EX5DN/wpEFFEmZIytyY3Ys12aD/tyrOrPwfIlya7BI83kLNsB/Lii/YM3UB/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aI+4ClAV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aI+4ClAV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753950580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UOsdViaGVxWnczW9b3BcwanE5/c/ybe0wyeENLeFccE=;
	b=aI+4ClAVLOJ4BPSeo7ek/PM4kHFgFIkXOIU//RFZbt8fqXkOPklYwo5XTdwtNq2W5SBfsI
	fdaRSzTqaOmvECYYJQ7NGICKYxxsIRU8kDhd17S8Ser0gU82vLoYc3rpxz1+EqLOj7hYjA
	lLQ9NPNzeUOOP9Lk5Jura18CK8Q/XZE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-kDc3tIEyOEa-_NAHRd1BjQ-1; Thu, 31 Jul 2025 04:29:38 -0400
X-MC-Unique: kDc3tIEyOEa-_NAHRd1BjQ-1
X-Mimecast-MFC-AGG-ID: kDc3tIEyOEa-_NAHRd1BjQ_1753950577
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7807a33faso60366f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753950577; x=1754555377;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UOsdViaGVxWnczW9b3BcwanE5/c/ybe0wyeENLeFccE=;
        b=QcbeEYdNNm0uZa1LnJouTZDwBnwY8/jq9mrLWkPXzbzCZWz1hNuq5BIbFa5kGwTkU4
         ijPlJovxV/GJJUQBjDSN2WOP+LxTX256YKcJgHgau7h7uptJfAL/a9tA8KFSQeyC+pXM
         LRo7IYU5yjJcAKL5cg4jCbi89CnLtZjt6ANDEeBZny/nmrFLsLkK6W9jD4sRW+wu9cE4
         XswKB+KuGA2L7V3VuBE98muCvE5g9LMv9rXNqBl6WzDyIdbymOE+703kLOmiOviHxJgF
         Clw3kwyawsksJ8KYNFVA6PlbV9dxjGKGa3qJrrSEqeSJJIo45Xn4vW3hMd3fvdt8ZWF1
         tvuQ==
X-Forwarded-Encrypted: i=1; AJvYcCULsu1Q2rEMCimn5UD7GZK8n0KjlqZGNms6PyxkFjQHx99M7Q019Kmp3pwt+VgwCI6M0a0auWo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4zFNA1FvidDQAEkBW2WwkUqgj1POeDchpazJ2QAOrek1RnndH
	useNT3Benr4yGU75OI7cPlehegnVH8ebd/fe5GgSxtiZssv5zmgIMWEpe8MlfWiZph/NMBhB4Ew
	ncS+IuKZ9frgtvRz5yP3MXsOsY2hvKZ6Muz4RFrcaLpDUbNmu6pqxbOJ94z04VFVOmoai
X-Gm-Gg: ASbGncsOUx8cn2jKFURV/LEVGKr8mnMApPIn8baSz7CjawhYrBX+xXha3tvL1+pTVe9
	I2K9+xdJ7zsFWnurC3X4A5PJL7aV0jMQG5xose7wqbq0oGlgDkhBVrEyt7kWZJQ4XJzz5k1a4PK
	l3mbyL5xesymqYatTuu4i+49R7w45SqKc1UQXauImKHcAsqAx5bp9B76L36I5w6X3cFQNoQ1NCb
	EVMumox25ukp41uniLI7MY7LahRbV7D5O0B6f6P8d/a53/WZeMEwujncop+j6+cKtuOUsZgHEQS
	Nkt5vPXh6zEmPwNnlqEvfk+7noa9MfEF3exMABickUo7IIJcmnne3u9FQUBPqzp5PPtc9UfJn5u
	z3t5j6/VykM+p78/WENU4UyZz7JYNVK2jWhNj941rtt+lcFtT0M8s4UeflmRFNpnDF1I=
X-Received: by 2002:a05:6000:24c9:b0:3b7:9c88:daac with SMTP id ffacd0b85a97d-3b79c88dbc7mr1204228f8f.53.1753950576902;
        Thu, 31 Jul 2025 01:29:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHD9vjWTXx6+eu57zSZvMsNC7w4A10Bd7geesiciB9rOpCXqiI0Bh3Cw4/xj0sZFbPQ7RH2cA==
X-Received: by 2002:a05:6000:24c9:b0:3b7:9c88:daac with SMTP id ffacd0b85a97d-3b79c88dbc7mr1204197f8f.53.1753950576339;
        Thu, 31 Jul 2025 01:29:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm1588913f8f.18.2025.07.31.01.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:29:35 -0700 (PDT)
Message-ID: <c320b7a3-bf75-4f9e-bd72-4290fd9fe9d9@redhat.com>
Date: Thu, 31 Jul 2025 10:29:34 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 12/24] KVM: x86/mmu: Rename
 .private_max_mapping_level() to .gmem_max_mapping_level()
To: Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>,
 James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-13-seanjc@google.com>
 <CA+EHjTwuXT_wcDAOwwKP+yBetE9N46QMb+hUKAOsxBVkkOgCTw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CA+EHjTwuXT_wcDAOwwKP+yBetE9N46QMb+hUKAOsxBVkkOgCTw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iNw173g4TQsGLbTEAbvMnz5Nk6p6b8biZRTOp-J7Kpc_1753950577
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31.07.25 10:15, Fuad Tabba wrote:
> On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>>
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
>> in anticipation of extending guest_memfd support to non-private memory.
>>
>> No functional change intended.
>>
>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> Co-developed-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
> 
> nit: remove my "Signed-off-by", since I'm not a co-developer, and instead:

The patch went "through your hands", right? In that case, a SOB is the 
right thing to do.

"The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path."

-- 
Cheers,

David / dhildenb

