Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD948F60
	for <kvmarm@lists.linux.dev>; Thu,  2 Feb 2023 20:22:52 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id q3-20020a5edb03000000b00725625524e5so1801365iop.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 12:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8NI8G3MUYPvndKeLhb40B6Enk6uRYjAAMWKfkextf2M=;
        b=UaBYKtKt7rp3wgxND80ZXGrnXhekOH2cnt3JdZ77hj5WIocLRssJdyDD4Eu60caONX
         2SwG8AGmDsrN8H4JkHy0dw6he5oTxqshx2PPiUc7MV/3wPminTlmgQ8A5/t4NoEAI6J4
         O6ESjZGIUgAkxADlqOHmO/dPxJSznbG+YfoAtNPAfTlrfw709h71p2IFbOdTFgjKAy8E
         8dHTLii+y9Ynl7R7pEaBbkvEm1CfUpWEGr4wqES8umdZ6Boa95nrDF9Cyvp98p0XGuN7
         Yg093nEpOqEOj43d9PanB/webQYB3pHsEIG1G0v6hCRxeqJnNSrmFSigO7eT4XT+ozxb
         8xQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8NI8G3MUYPvndKeLhb40B6Enk6uRYjAAMWKfkextf2M=;
        b=Z+NWGWVaxeoLSHIb7aQVSeOu/hmMWRVEYmisVRuLE9pY+9/+ypSIpmwN2htViRTis0
         mFED/sBLccKpJavYBseWHLH6wSErVZPtbDEtSqEEA2jQU/zok0Lir+oKdEmqltaQxlwh
         CksZqLQx4TARbxWg5GOfqwCZxViSvijO51GfCBDbqYhEzthsAiWNFK2PpiWqYoFTdP6k
         PX//RrYyo3GyHQsLs8nzKCcEEgF+2N4FBYMoxBrxsyhpC2BO5kMLBcDbdqkTuIE98jDm
         mHV0ABRKoa1BNC4krQqoWY+Ea0aav5yrPFGpO/DCQy5XIJyt2tOCzrcTlGcUnZpIdNi9
         kMUQ==
X-Gm-Message-State: AO0yUKU5KgI+AMTodnRR9vLNgK2xQCTnpuYcQt6BUud9FXVE7wSSPH63
	XH0kZcf4OagfPUYD8ouooC6IkIKXLxH0QcCQqg==
X-Google-Smtp-Source: AK7set/4mwqzZMqy6bglBKnpA4nqxRTU1S7BEtMfTbq8gbWNzmgAHZ0e8NkIoN3dklrEn2IzikHViI5fcUDIDtN4fQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:492:b0:715:fdfd:318a with
 SMTP id y18-20020a056602049200b00715fdfd318amr1822920iov.78.1675369371775;
 Thu, 02 Feb 2023 12:22:51 -0800 (PST)
Date: Thu, 02 Feb 2023 20:22:50 +0000
In-Reply-To: <20230202080122.2kbtmsbcu45pzr4f@orel> (message from Andrew Jones
 on Thu, 2 Feb 2023 09:01:22 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt4js3yfz9.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH v4 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
From: Colton Lewis <coltonlewis@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	imbrenda@linux.ibm.com, marcorr@google.com, alexandru.elisei@arm.com, 
	oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Andrew Jones <andrew.jones@linux.dev> writes:

>> +# error first. The awk program takes the last number from the QEMU

> I point this awk reference out in the last review. I also stated
> we should do something else, which is not done in this version.
> Go read the last review comments again.


I apologize for not reading your last review more closely and checking
my work. I read your word "comment" but thought you were only referring
to the commit message since that's where you placed the text.

As for the something else, you mentioned wrapping the code in an $ARCH
check but stated that should be another patch. I did not catch the
followup where you suggested doing it now.

I will do that next version.
