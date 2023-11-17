Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E427E523A
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 03:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jW0lyQ0f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700191181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jAKFfPiqJuGzP2s6H3e1McPERpD8hKdLrmeMzG7k6Hw=;
	b=jW0lyQ0fafUKH7KIpRD8WNF0Xb5TpBTaG2KnUDp0PUnlkurNrAqLRH46lV4rTDN4myTq+A
	V7FFa9OEek8XbKZY/pXLYFx12i1wHoevGySkWQlQvUkd90q8Z3TnZBRiz7OQRtKTO3XF7f
	L154wgVzeihgOLkviFb0UiCM3PsfQ+Y=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-Acl5IcKqOBuH5bFJiyRUeQ-1; Thu, 16 Nov 2023 22:19:37 -0500
X-MC-Unique: Acl5IcKqOBuH5bFJiyRUeQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6c36adea2d6so510640b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 19:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700191177; x=1700795977;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jAKFfPiqJuGzP2s6H3e1McPERpD8hKdLrmeMzG7k6Hw=;
        b=ZPz2Xc1RF+5Ff817YdtZpeGJY44v4EplB63u+dY3yJL51kLsbV0jFiR14vYflUdL88
         AhnBwuIrRH6+Wgtcqj7AHFCwzjbuV32BZJn1Q6i69CC7j8lzRpt9D7N7KICtd0i2qQ3j
         dpy8dpp7RRchRN9D1C2358H8BndAjQ5TaUtIik4chiwVmN7BYFpIgBC93vQXentKLEiJ
         K+jAEXkntfdc4TbPlnnNccZ/GWUxewU9DJCntk7dhCvu67MKY6VO8MIITyy4N9o7LPAj
         cIJ3JXOWmWqx1H1OwMAUKbJQ1OSJP3svJeOTFPTnESbhvJKj4SosxzBtc2x+q097jw+y
         6slQ==
X-Gm-Message-State: AOJu0Yy7aR5T+TK5UdLEUmys4/wDWssU2rSbuR/TDfo6VVwdnOm1YO7a
	403ejsIOWGEXdJwS5TgtgCiVVrmctBc6N53DzosemOhWdTQyqPBKdQn2RXHfLdFrGgfNDYXrHgJ
	kZvbZWYhgIQjc4Pin
X-Received: by 2002:a05:6a00:8998:b0:6b3:c72d:b01 with SMTP id hx24-20020a056a00899800b006b3c72d0b01mr8240469pfb.1.1700191176694;
        Thu, 16 Nov 2023 19:19:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFfpURZkDv/ezuJd6cSD4adKTKntnTXg/JeSPEJHMKPZoI8mQ8dl34F8ROKL9i11G2GXcaKFg==
X-Received: by 2002:a05:6a00:8998:b0:6b3:c72d:b01 with SMTP id hx24-20020a056a00899800b006b3c72d0b01mr8240451pfb.1.1700191176340;
        Thu, 16 Nov 2023 19:19:36 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id it14-20020a056a00458e00b006c8721330fesm455416pfb.74.2023.11.16.19.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 19:19:35 -0800 (PST)
Message-ID: <041416db-1cb5-e84f-ce44-9d06707970a8@redhat.com>
Date: Fri, 17 Nov 2023 11:19:32 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1] KVM: selftests: Initalize sem_vcpu_[cont|stop] before
 each test in dirty_log_test
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231116093536.22256-1-shahuang@redhat.com>
 <ZVaxXJ4xUW1eyQEL@thinky-boi>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZVaxXJ4xUW1eyQEL@thinky-boi>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 11/17/23 08:18, Oliver Upton wrote:
> Hi Shaoqin,
> 
> On Thu, Nov 16, 2023 at 04:35:36AM -0500, Shaoqin Huang wrote:
>> When execute the dirty_log_test on some aarch64 machine, it sometimes
>> trigger the ASSERT:
>>
>> ==== Test Assertion Failure ====
>>    dirty_log_test.c:384: dirty_ring_vcpu_ring_full
>>    pid=14854 tid=14854 errno=22 - Invalid argument
>>       1  0x00000000004033eb: dirty_ring_collect_dirty_pages at dirty_log_test.c:384
>>       2  0x0000000000402d27: log_mode_collect_dirty_pages at dirty_log_test.c:505
>>       3   (inlined by) run_test at dirty_log_test.c:802
>>       4  0x0000000000403dc7: for_each_guest_mode at guest_modes.c:100
>>       5  0x0000000000401dff: main at dirty_log_test.c:941 (discriminator 3)
>>       6  0x0000ffff9be173c7: ?? ??:0
>>       7  0x0000ffff9be1749f: ?? ??:0
>>       8  0x000000000040206f: _start at ??:?
>>    Didn't continue vcpu even without ring full
>>
>> The dirty_log_test fails when execute the dirty-ring test, this is
>> because the sem_vcpu_cont and the sem_vcpu_stop is non-zero value when
>> execute the dirty_ring_collect_dirty_pages() function. When those two
>> sem_t variables are non-zero, the dirty_ring_wait_vcpu() at the
>> beginning of the dirty_ring_collect_dirty_pages() will not wait for the
>> vcpu to stop, but continue to execute the following code. In this case,
>> before vcpu stop, if the dirty_ring_vcpu_ring_full is true, and the
>> dirty_ring_collect_dirty_pages() has passed the check for the
>> dirty_ring_vcpu_ring_full but hasn't execute the check for the
>> continued_vcpu, the vcpu stop, and set the dirty_ring_vcpu_ring_full to
>> false. Then dirty_ring_collect_dirty_pages() will trigger the ASSERT.
>>
>> Why sem_vcpu_cont and sem_vcpu_stop can be non-zero value? It's because
>> the dirty_ring_before_vcpu_join() execute the sem_post(&sem_vcpu_cont)
>> at the end of each dirty-ring test. It can cause two cases:
>>
>> 1. sem_vcpu_cont be non-zero. When we set the host_quit to be true,
>>     the vcpu_worker directly see the host_quit to be true, it quit. So
>>     the log_mode_before_vcpu_join() function will set the sem_vcpu_cont
>>     to 1, since the vcpu_worker has quit, it won't consume it.
>> 2. sem_vcpu_stop be non-zero. When we set the host_quit to be true,
>>     the vcpu_worker has entered the guest state, the next time it exit
>>     from guest state, it will set the sem_vcpu_stop to 1, and then see
>>     the host_quit, no one will consume the sem_vcpu_stop.
>>
>> When execute more and more dirty-ring tests, the sem_vcpu_cont and
>> sem_vcpu_stop can be larger and larger, which makes many code paths
>> don't wait for the sem_t. Thus finally cause the problem.
>>
>> Fix this problem is easy, simply initialize the sem_t before every test.
>> Thus whatever the state previous test left, it won't interfere the next
>> test.
> 
> In your changelog you describe what sounds like a semaphore imbalance at
> the time of test completion, yet your proposed fix is to just clobber
> the error and start fresh.
> 

Yes. It's a semaphore imbalance problem.

> Why not nip it at the bud and fix the logic bug instead?

I have another patch which fix the logic bug, I will send it out later.

> 

-- 
Shaoqin

