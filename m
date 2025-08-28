Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49F630FC14
	for <kvmarm@lists.linux.dev>; Thu, 28 Aug 2025 12:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385419; cv=none; b=A7zrK8fD+DCzWGYQqqQr8qBH00gNLNkpdNB4mSVYQULE9rtNeINjM473S8TGEpWWUqRSTSmXVoQyJY1JrlRBS8MaYpC5dH+ASbcjchNY35Eppf3Hkd9KkID9eSpThksEF2KsBs3zOmj3Aj4KeuA2cNlQBpGDYgJobteXp4oiGto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385419; c=relaxed/simple;
	bh=F9B87foFu5ArbaO6Wj5uzuuQ1mnMFqS0rUW4rnQy1/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t/JUu77PPLdUgEfT7uRDTjl77Q6HjV3aWT3QwFmGAja7Aj7kM8COa+dw1R6IVvKvbyuU3bMLZgWhlq8UAE9V+QG/UVNsaYAxAW5tw1GIcY7DXHipso+XA/JEvJAw/uxXa6ongq8S8DdgokULJ0uFauawMS/ca82tgmhaj5NAyVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aruokTaf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aruokTaf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756385416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C6iCBik3cJC1ZHjD5Ysxv05sd4NeodNwL7TaQOabYOc=;
	b=aruokTafr2v2Fmm28ssyUu4JSW0VmA+uSAdALjQWsmiFZNWfVsD0x7qljaFpYUpDXS9aJ0
	LgBKdZ7+K13lQJq9xkbheGH5D7TMmyh5XqzOZ69s9bfKSI6wSsksfkFIIAJTbq4DOiM5OQ
	KGPuAU8pi1WitLjHlOH+jcK0xMFU0jo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-G7C7bKQCMxiYJlcJ-KmRRA-1; Thu, 28 Aug 2025 08:50:15 -0400
X-MC-Unique: G7C7bKQCMxiYJlcJ-KmRRA-1
X-Mimecast-MFC-AGG-ID: G7C7bKQCMxiYJlcJ-KmRRA_1756385414
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c7aa4cf187so636705f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 28 Aug 2025 05:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756385414; x=1756990214;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6iCBik3cJC1ZHjD5Ysxv05sd4NeodNwL7TaQOabYOc=;
        b=e89dNrx2rfuZj6OBr07WGHuxinL8GmLXBR/ljHwMT5ZKFNepO8nlHi6qHlgl9a/UQe
         fxfguR1kEpfPMnQn5rHxM/W2ddWlW6j1+GQyp1UQmfNVR+TJbydiwiKl+xNJrQeicWeD
         Sf2j5ppKNxXSNncQJnDRAs6wu3/lsXPQU/vIVVN5p3x3yUysStzdcP2j0+DyJFZveOir
         9OtGd/CbzyHW7Z+IWIBJv5rzswQBo8LAmJYWnxYBt2OdVis6iBeXHADNqBxdBq8yJkUr
         UJ7b0hg/gtVLJajQFchqzZw0C0JBmRjG4cgS19brB0W7Bwf9L91rWZgE6/2AdyVjdyzv
         IB9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWftFC5gRk5vSilvb8zUq08HwdlpHbkxz/jpaYhp0dmX2dF8oJ2SfuO67H8Y61IR9PEWysNmTI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpWfgjW8sFRJoCiYsD7H6ARzxuzFylUbI50KuxLo3AMufxvSUa
	pk11odYtJI1NUS0EPLUSU9bOKFUyq/CBVr8rwpS7zan8iamIkZkc/8teLooVSY0GVay3/6c+AiN
	iPYEagaSwHhpNEtGc8IPkYEr4Km+C+bhmJzQn9AZFkQ1vTEfxYCWhQIy6yw==
X-Gm-Gg: ASbGncvfM8Jmt9MMTggYkbVeu+Nk3o8Bz1ZUdIDHXny1ww7MvWvO903DxOrdmy3N3ow
	BQhjlabsp/67d/g5O1yDeNNF0pU77hNBJod2fxDh5UzfDqKNCya9+Wqos3T/MpSw/+D1J8d7YWR
	mxfkluGMstP5mhkWfnPF9OL13/7KWXY4szlhZi4SRcMmZCOvx6FGTVGz7WmrCeaOvpQHGuXKLv/
	DKe9U+S1UBGMlSX8gQildLEQ0X6u4lRgwQiVwfbjIs6rGk7pvx9GZbeiUUHNJnlVd4Pn+01x3Ik
	5jQ+/rcrr1gUBOgdtxagiw7Io0Gg8JURIRpyqpqETnVtHfLPgSkPQmaWxmnaLoSZSDLv1XVHP9k
	/wQjkDN1kkPPklPez4abO4dF5ihGPdY/uv3m0IbFssj86JB67iAjSEJ0Get2ywPFlGgw=
X-Received: by 2002:a5d:5d01:0:b0:3c7:36f3:c358 with SMTP id ffacd0b85a97d-3c736f3c59cmr13147590f8f.32.1756385414253;
        Thu, 28 Aug 2025 05:50:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2soHNJz3uNCh9kCpxwV5zoV5iezSYMFN+6bV3UPfCImuAc7IMpQupU9NYnIVeAMq/TCo6Vg==
X-Received: by 2002:a5d:5d01:0:b0:3c7:36f3:c358 with SMTP id ffacd0b85a97d-3c736f3c59cmr13147562f8f.32.1756385413775;
        Thu, 28 Aug 2025 05:50:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba44fsm24519526f8f.5.2025.08.28.05.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 05:50:13 -0700 (PDT)
Message-ID: <a777f88b-ea12-4aad-88da-2e7011e151b8@redhat.com>
Date: Thu, 28 Aug 2025 14:50:12 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] Direct Map Removal Support for guest_memfd
To: "Roy, Patrick" <roypat@amazon.co.uk>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FE2wKWo5_UZKxocZuw5n4f6qikhpRCtpPWNBjsONj98_1756385414
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 11:39, Roy, Patrick wrote:
> [ based on kvm/next ]
> 
> Unmapping virtual machine guest memory from the host kernel's direct map is a
> successful mitigation against Spectre-style transient execution issues: If the
> kernel page tables do not contain entries pointing to guest memory, then any
> attempted speculative read through the direct map will necessarily be blocked
> by the MMU before any observable microarchitectural side-effects happen. This
> means that Spectre-gadgets and similar cannot be used to target virtual machine
> memory. Roughly 60% of speculative execution issues fall into this category [1,
> Table 1].
> 

As discussed, I'll be maintaining a guestmemfd-preview branch where I 
just pile patch sets to see how it will all look together.

It's currently based on kvm/next where "stage 1" resides, and has "Add 
NUMA mempolicy support for KVM guest-memfdAdd NUMA mempolicy support for 
KVM guest-memfd" [1] applied.

There are some minor conflicts with [1] in the "KVM: guest_memfd: Add 
flag to remove from direct map" patch, I tried to resolve them, let's 
see if I messed up.

https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/log/?h=guestmemfd-preview

[1] https://lkml.kernel.org/r/20250827175247.83322-2-shivankg@amd.com

-- 
Cheers

David / dhildenb

