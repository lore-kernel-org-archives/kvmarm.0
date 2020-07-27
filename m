Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1018BC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:25:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9202C20672
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STcNhQnQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9202C20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CEF94B818;
	Mon, 27 Jul 2020 13:25:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IclYkl6mifQ2; Mon, 27 Jul 2020 13:25:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 140264B5C1;
	Mon, 27 Jul 2020 13:25:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34D574B5C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:25:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6vKGpp07sxfc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 13:25:27 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D3A44B58E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:25:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1595870727;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ez7WeArkgioY0VlcfnY8q3j7rpYtHgMsNNYFl+uG8+0=;
 b=STcNhQnQbKnn8x9zpgNndU8T3QD3POHGUo5rAwNxto/yjB5wPavFkmp/OLoJlXijZeohZl
 tNbcM/BcWz6rLgDFvxrTagizybDLJ+xQzwS1MZ+erBeH9/jAZ0/NF33M3iPzBD04vn4ECo
 VrMsiKn9khPDgsb/ExO/C6+SnQmvdjc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-T0iLziDzNW-AYbWyX0tRow-1; Mon, 27 Jul 2020 13:25:25 -0400
X-MC-Unique: T0iLziDzNW-AYbWyX0tRow-1
Received: by mail-wr1-f72.google.com with SMTP id h4so4189109wrh.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 10:25:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Ez7WeArkgioY0VlcfnY8q3j7rpYtHgMsNNYFl+uG8+0=;
 b=REKpmFZkfabwwK1eVgltZ2bMlRe8VpvBZ0F1m5WMeUsE4sAi0kRx/K218KFzwVNt0g
 Wf+0TSK4RA7JbkT0AdK4Al8MTqO4MfVlhkjDjCMkeZsS/pcp7Brf0WdtNiXRXhU3ix0o
 HCYh/CXmzmYfXebiQ6oAL/fs6Anba94SZXfmEn8/Mm9u6F3Ut+GAZuROdvgJyN6ENX+2
 z49PiEe68zdW5PpfadOINPX/6p/A1eeA+bC2hEh84qAmCc58h9rUCfXfRKU2ckWw1UBA
 qiYH06Qc0w115g1uBbwZ6XP0mOeB2XjJZg1WoejsGauypdStq89epHviOsUpBquU14Wv
 6x4A==
X-Gm-Message-State: AOAM530/qCdMGhiyO567jjuQa/iafkn5PoKrSUaz0WkW8hMdiJ8NchqP
 r55PHnbdQYclElcEYBaJc32dQaXvx32ZSChiMebUvTlpsGkXW/tPnOBFUJag9wvMtv8iP61bpY6
 WiU0SE0KoIYujhtOh4iMj9fSh
X-Received: by 2002:a1c:80d0:: with SMTP id b199mr332456wmd.28.1595870722982; 
 Mon, 27 Jul 2020 10:25:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoV6Ud8vEStX9/KvnrqXEZPu6H8nd0FdSRYXzSjf3jHkiNLbDvOJ4PNJmEyHTo5QR6LuXFIQ==
X-Received: by 2002:a1c:80d0:: with SMTP id b199mr332449wmd.28.1595870722789; 
 Mon, 27 Jul 2020 10:25:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:80b0:f446:bb61:1dbb?
 ([2001:b07:6468:f312:80b0:f446:bb61:1dbb])
 by smtp.gmail.com with ESMTPSA id v29sm14547080wrv.51.2020.07.27.10.25.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 27 Jul 2020 10:25:22 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] arm64: Compile with -mno-outline-atomics
 for GCC >= 10
To: Andrew Jones <drjones@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20200717164727.75580-1-alexandru.elisei@arm.com>
 <20200718091145.zheu46pfjwsntr3a@kamzik.brq.redhat.com>
 <202d475d-95df-2350-a8e9-9264144993ac@arm.com>
 <1bf2eab6-c6df-8b4c-b365-7216e7b9a9d7@arm.com>
 <20200727123031.7v52lu23mmhailar@kamzik.brq.redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b47a7fc1-fca6-4401-ab47-4167d37eab8b@redhat.com>
Date: Mon, 27 Jul 2020 19:25:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200727123031.7v52lu23mmhailar@kamzik.brq.redhat.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 27/07/20 14:30, Andrew Jones wrote:
>>> Looks much better than my version. Do you want me to spin a v2 or do you want to
>>> send it as a separate patch? If that's the case, I tested the same way I did my
>>> patch (gcc 10.1.0 and 5.4.0 for cross-compiling, 9.3.0 native):
>>>
>>> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Gentle ping regarding this.
>>
> Hi Alexandru,
> 
> I was on vacation all last week and have been digging myself out of email
> today. I'll send this as a proper patch with your T-b later today or
> tomorrow.

Same here; will wait for Andrew's patch.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
