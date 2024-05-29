Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF7CD52E
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717003074; cv=none; b=dreX6YbuWWG7N8siytCGosnq1tCkfkH2T+hUF7zqciDz3aixXPdJH1BGKAPSrhOrp8qHww1xaJWNLBTQQXX5h04nkK7VvhL84SEmJH1FRSNlD3YRlWkzLeIxdJs7JBcpkgDQBN5ZNbRCqlrK49yJS55eBqAKVrPaqLnHzlANpKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717003074; c=relaxed/simple;
	bh=HRL5ucaZ3hB/3mleme94MeO065BSrwW91Qyz+lyN1pA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a/8mCF+YU1q+KKsuDrXlyksys/vfaDJaLSUhgnrPwyWfHlR65u6SOsvGT+IBzKOzMUA/2tYnY0QynEpNyGamM7N4SLboGqxQCc6h8iWd2Nxyb3MyRoOapQNdBsRS6ADSZkRfyJwc+mZgEkmqTejsDzs1XbAuZYmddFlZs6FJL7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W10FHMPQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W10FHMPQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717003072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BUv7XG4pn3BZlXmqpi1zpSIKGCzhas+XxFu5FSvHJzQ=;
	b=W10FHMPQu2lYl+1QfBXb7ysdYRBOhziFzLydIjgqAgLLqJ56EKwwpamqmAbW34B9MjvlTT
	4L6rtBY+ilGg0Es5lNJP9svZE1qjYqRSup1aHteGHmSr4ypPRcBpp4Brst/vTxxrN8bUgn
	hm71h4CXen06gkfulM/t4o+ZErnOCc8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-oTmkrvDHPMSC3BUV8TIzLQ-1; Wed, 29 May 2024 13:17:50 -0400
X-MC-Unique: oTmkrvDHPMSC3BUV8TIzLQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-43fd36dcfdcso25079281cf.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 10:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717003070; x=1717607870;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BUv7XG4pn3BZlXmqpi1zpSIKGCzhas+XxFu5FSvHJzQ=;
        b=J8TqB46l8x9sHrXjJ1u1tAV1PFytm4+sBTf3K4QjRF1cPlM17kyJa0cisBctJjnXwC
         LSjE5M2RW8KvQsjefUlr91efjnBfiE4NzJHihBZ+6W6amuGZsKR9D/XqacQOgflSWPqd
         A4aysoMH/DVJFqzPvQpypZvKnZMEh27OQTwbU9NoFKCq8pYFQNIiVqMMy3HSgW4CD8a1
         maeXNQjJzjf8seC1CfY/u1Swvc+1QZ4EeVz/+N6iMHOdFdrvfrkBj8+kIOg2EbrrAx7Z
         CZNMgk4MZ1PXEhdWNgpTxxmRuGqMOnS3je3Q0zh3rYvkPavUIkfnrqcCQhCaxBjTGtND
         NF3w==
X-Forwarded-Encrypted: i=1; AJvYcCVLl5TSQg1co3k7UE6h2hFFWSmi1XeG4S5uB7k7Be1HdA0Yn11n/lYGwB/p3fpH/oURQOs0XJz+0fCAX4UW6XtpxbBbPUq5
X-Gm-Message-State: AOJu0YzF9gGQo3rEIxfV8xspST22wBKLF/JAq6aPS+ZO+m0uTugor1s8
	5yrep+cRKqXc71UcKVBwE0FfzfBbVl4lJVgffqkQuwXcYIWZIFJihlyl3tL/uHS/r/OsS2t9StL
	aqMcFCkkOCcc+LzmCTkmpQ3TflaINP2ker/+7HJyG+kiIt69b9dE9Aw==
X-Received: by 2002:ac8:7c49:0:b0:43d:e4c8:8059 with SMTP id d75a77b69052e-43fb0ea5fe0mr202225571cf.38.1717003070031;
        Wed, 29 May 2024 10:17:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPhv+rJGDUBPVu3ue7naEkW4C1RVt6Bk1ld4bFm4zpbG8GKGPbUuO/g7eqHWUwbs4l5gK7kQ==
X-Received: by 2002:ac8:7c49:0:b0:43d:e4c8:8059 with SMTP id d75a77b69052e-43fb0ea5fe0mr202225211cf.38.1717003069653;
        Wed, 29 May 2024 10:17:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43fe57b7014sm5448301cf.80.2024.05.29.10.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 10:17:49 -0700 (PDT)
Message-ID: <1af3cb52-4311-4375-b384-71b0adeb8a32@redhat.com>
Date: Wed, 29 May 2024 19:17:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] KVM: arm64: rename functions for invariant sys
 regs
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20240514072252.5657-1-sebott@redhat.com>
 <20240514072252.5657-6-sebott@redhat.com>
 <b045f810-eb79-4de6-b149-0d64834d53d4@redhat.com>
 <5a00647d-7d33-81a6-c783-2212ff73ca8b@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <5a00647d-7d33-81a6-c783-2212ff73ca8b@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 5/29/24 17:29, Sebastian Ott wrote:
> Hej Eric,
> 
> On Wed, 29 May 2024, Eric Auger wrote:
>> On 5/14/24 09:22, Sebastian Ott wrote:
>>> Invariant system id registers are populated with host values
>>> at initialization time using their .reset function cb.
>> get_##reg call read_sysreg(). I don't really understand the above
>> sentence. Please could you elaborate?
>>
> 
> struct sys_reg_desc has 2 function pointers (among others):
> .reset and .get_user . The functions implementing these are
> usually named accordingly. For invariant registers only
> .reset is used but set to functions that are called get_*
> (which is usually used to implement .get_user).
> 
> E.g.: invariant_sys_regs[0].reset == get_midr_el1
> 
> When trying to figure out this code I was confused by this, hence
> this patch..

Ah OK, since ".reset=" was not used in the initilization I missed that.

feel free to add my
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric
> 
> Sebastian
> 

