Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75890A52
	for <kvmarm@lists.linux.dev>; Mon,  3 Jul 2023 08:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688371735;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FXPKfZsTXzahD7ycQScFS2q+Sn+AkPPRgq7/KVL7l/U=;
	b=g2UJrTGB+D/M8M9cCVZfZMdASRyfrPyL2w3hcjwNmxxmI57uGW7LKm2aYcL3dJlnW+ItFe
	nUVwHZFNHQ69pi7b4+5IoAIxKcpJVK9D6uVorYvbqbpU0TdG4z6slVzJRqk9Oukf0KEb1y
	v41x4n+tVa3PdtuqWWgFj0aP7skA4+c=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-r0woUOlCPnuHX3VzQ4moKQ-1; Mon, 03 Jul 2023 04:08:54 -0400
X-MC-Unique: r0woUOlCPnuHX3VzQ4moKQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-635e91cba88so47563776d6.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jul 2023 01:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688371734; x=1690963734;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FXPKfZsTXzahD7ycQScFS2q+Sn+AkPPRgq7/KVL7l/U=;
        b=UrKyJspapQ1yaRordeJh4x+Nb+I9IDc7ZqaXRIhk0C486chIXrpj/4bPV+FUOjIyMv
         n1QsyOwfpF3NBD/6iZXW09ae+sDoPKR4tR9l3MQi7VIA2AYKJlf6llYiW6oRiqZNaovo
         MAYaaw+P3F0icUnrpAmGs2+Xf95NN4w+qct+UNQ+BqUyV5g8WqSIVIDElMOW0ol4rY6c
         pRauSKNEhSulQAuEYa6auz2+PHhcesjQGjNUiFstbpq44hIAe7Og5YTst7XcpY046Mtm
         f9SLAy0mrtaBoDAoxUdWk7quUGLsfbUcAr77AyrXZgcgBqQOIgmY1lraP+JjZz27V/+E
         Qtsw==
X-Gm-Message-State: ABy/qLYdqKXgkWTIwrxziC17BmaS436BeMSaIn4NAKZ2rPKxKVMCSWhY
	TrYZDtkpWsUjvBMU0+J7/cPu2hQ5+ji+F12sK3IAjo4arwp9uP2aSSCPxFX98rwCXgBthryJXrc
	N2YCretosrw+W7e0j
X-Received: by 2002:a05:6214:c3:b0:635:de52:8385 with SMTP id f3-20020a05621400c300b00635de528385mr8486495qvs.65.1688371733896;
        Mon, 03 Jul 2023 01:08:53 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGKzp5ZiukExyOrvxJTeHKv24OOZijoaMTKRVV4KAAWAvgblhqLeAZDPyKzp3kaChdmwgOQmg==
X-Received: by 2002:a05:6214:c3:b0:635:de52:8385 with SMTP id f3-20020a05621400c300b00635de528385mr8486485qvs.65.1688371733711;
        Mon, 03 Jul 2023 01:08:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l15-20020ad4444f000000b0062439f05b87sm11201681qvt.45.2023.07.03.01.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jul 2023 01:08:53 -0700 (PDT)
Message-ID: <6b7c593e-d735-93ae-2e5c-99d87b4604cc@redhat.com>
Date: Mon, 3 Jul 2023 10:08:49 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 5/6] arm: pmu: Add
 pmu-mem-access-reliability test
To: Andrew Jones <andrew.jones@linux.dev>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 maz@kernel.org, will@kernel.org, oliver.upton@linux.dev,
 ricarkol@google.com, reijiw@google.com, alexandru.elisei@arm.com,
 mark.rutland@arm.com
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <20230619200401.1963751-6-eric.auger@redhat.com>
 <20230701-daff0cec48c2329abd7ede9f@orel>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230701-daff0cec48c2329abd7ede9f@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 7/1/23 13:36, Andrew Jones wrote:
> On Mon, Jun 19, 2023 at 10:04:00PM +0200, Eric Auger wrote:
> ...
>> @@ -1201,6 +1257,9 @@ int main(int argc, char *argv[])
>>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>>  		run_event_test(argv[1], test_basic_event_count, false);
>>  		run_event_test(argv[1], test_basic_event_count, true);
>> +	} else if (strcmp(argv[1], "pmu-mem-access-reliability") == 0) {
>> +		run_event_test(argv[1], test_mem_access_reliability, false);
>> +		run_event_test(argv[1], test_mem_access_reliability, true);
> This breaks compilation for arm since this patch is missing the stub.
> I've added it.

sorry for the oversight and thanks for adding it ;-)

Eric
>
> Thanks,
> drew
>

