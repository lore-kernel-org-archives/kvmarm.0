Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D22024209
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696338198;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3GFwg56FjUnk/RYyxX0j6V0Iiz4DYd4P83sGmmUcaE8=;
	b=KxXYstQj2QNguSZW2zsV5Z9VYPBh9a59t21Z+UjiLVTCRyctEF3MSJI3PqdGPJhshDTdLc
	L99AeKipRacMXHSt1fs7LtVaQRVkoOVOpk0iUHmq47FKTYUldyibL+GGmf7Kmxr7fNGqgn
	LCCQOJcBLgfs5TKy7utlPNqIX+zl6M4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-ARjsyz0wMkm1Zdq5TumuvQ-1; Tue, 03 Oct 2023 09:03:01 -0400
X-MC-Unique: ARjsyz0wMkm1Zdq5TumuvQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-65b1c33bf59so9623806d6.3
        for <kvmarm@lists.linux.dev>; Tue, 03 Oct 2023 06:03:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696338181; x=1696942981;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3GFwg56FjUnk/RYyxX0j6V0Iiz4DYd4P83sGmmUcaE8=;
        b=KNq2chTNl+r3Xg5oQIUkstymqFUecIbNFGd7qqoGXNiNOMQQeVv0TjkKH8lGqnwCYP
         /QIQmYnC8fZnwvSGWtHSbASjFA7FOih25rXsfaMOdJO3QAoBmZNGAbRgiURj2sAfjmue
         LREZg/9gQ/L8m5VEYKSnOo6B+iHDPpX6As3oFBkNyruevZte0upiJLFNYBuYaIyflkHZ
         wiTsCwOuixK5DKvSn7ClVRDuNn9CnzP4DIrsE8CWmN8IfCwVFXXuVUIO8hm4xkQjwaNn
         WKtV4TW4sywZ16y8OQku11RNlW7wk/4VcXlfcXhLtptNhaDJdktQcXs32jvgHz6/kJHH
         YLBw==
X-Gm-Message-State: AOJu0YwojUKRoXpXCQSE3C9U/sHIw6wK3QyfK2x/rOBZqimTxKiN3U/p
	zqzbBa+omSdrjGXmTk8qB/xnqcUy4sBQl+NMed9hijfwGzei8GC1sWHBd14VnmxGIuILAMx1oko
	FJ6GrA0/+FiAMssea
X-Received: by 2002:a0c:e184:0:b0:64f:3bec:9b29 with SMTP id p4-20020a0ce184000000b0064f3bec9b29mr16313138qvl.39.1696338181294;
        Tue, 03 Oct 2023 06:03:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFu2JXglfNoNOa1zYOGFmLH18oaA0qRkmgTq9KV7s1VRSKyL03flSA7O6FwDPBplykwo50Vg==
X-Received: by 2002:a0c:e184:0:b0:64f:3bec:9b29 with SMTP id p4-20020a0ce184000000b0064f3bec9b29mr16313116qvl.39.1696338180979;
        Tue, 03 Oct 2023 06:03:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s2-20020a0ce302000000b0064723b94a23sm453235qvl.27.2023.10.03.06.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 06:03:00 -0700 (PDT)
Message-ID: <ef81a814-2733-8c1a-bfb0-bb1187881c94@redhat.com>
Date: Tue, 3 Oct 2023 15:02:57 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
To: Matthias Rosenfelder <matthias.rosenfelder@nio.io>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
References: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Matthias,

On 9/29/23 23:19, Matthias Rosenfelder wrote:
> Hello,
>
> I think one of the test conditions for the KVM PMU unit test "basic_event_count" is not strong enough. It only checks whether an overflow occurred for counter #0, but it should also check that none happened for the other counter(s):
>
> report(read_sysreg(pmovsclr_el0) & 0x1,
>       "check overflow happened on #0 only");
>
> This should be "==" instead of "&".

Your change indeed makes sense to match the comment. Please resubmit
following Drew's hint and feel free to add my

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
>
> Note that this test uses one more counter (#1), which must not overflow. This should also be checked, even though this would be visible through the "report_info()" a few lines above. But the latter does not mark the test failing - it is purely informational, so any test automation will not notice.
>
>
> I apologize in advance if my email program at work messes up any formatting. Please let me know and I will try to reconfigure and resend if necessary. Thank you.
>
> Best Regards,
>
> Matthias
> [Banner]<http://www.nio.io>
> This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed. You may NOT use, disclose, copy or disseminate this information. If you have received this email in error, please notify the sender and destroy all copies of the original message and all attachments. Please note that any views or opinions presented in this email are solely those of the author and do not necessarily represent those of the company. Finally, the recipient should check this email and any attachments for the presence of viruses. The company accepts no liability for any damage caused by any virus transmitted by this email.

