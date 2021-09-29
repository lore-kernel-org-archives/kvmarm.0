Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E02BC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 11:20:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11A886140A
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 11:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 11A886140A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8445E4B11C;
	Wed, 29 Sep 2021 07:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e+slR5b5A9d8; Wed, 29 Sep 2021 07:20:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F564B116;
	Wed, 29 Sep 2021 07:20:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83F7B4B10C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 07:20:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5OxP6-sht7e8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 07:20:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 779524B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 07:20:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632914436;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QT1rFRDBhzmSS+/lGbt19+2aAndXLLtwvTkh1G4vaX8=;
 b=Cswm0QeTk1WyNE2MH8WI8CGhXf65dnA/VfUHKIf2ze+V5LPhmLiXdgR2ruGoAq5US1Kddo
 qJPXiNc9wzcWTXGBrkl9wce/0sk4BPwxN10ZqX+5sGEUqc39tJ49lULzqjRKqot4v3ilTP
 OOI+GYCqUQKmmVUsJ8hfRC19DKBvUGI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-TeWkpCvxOAGM0zJkKSc71A-1; Wed, 29 Sep 2021 07:20:34 -0400
X-MC-Unique: TeWkpCvxOAGM0zJkKSc71A-1
Received: by mail-ed1-f72.google.com with SMTP id
 j26-20020a508a9a000000b003da84aaa5c5so2036036edj.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 04:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=QT1rFRDBhzmSS+/lGbt19+2aAndXLLtwvTkh1G4vaX8=;
 b=HGNnoH3qvwTdxPd/pTY0nVpNhn93nj8f6Nr9hoIw+MnlnVfnbRiKey2TMy9VOkGq5O
 277YOFw/DAkxbhcNRjz14DIT71ACKZWkEmhvOnNjGQClSfsBeYFWn2Trf528hYVDNtZr
 mR487rRq814rohPZPg+99vJ+aVWKG15QXMd7oStoqGpuo5P0Vl48l0K3eBDmCpnnNvuV
 BvFxxQPkuRFJBAQDh1j6+6GDtra+sRy+vpTWTbPgU5enJst6UegNnjJ6fIn4yCtyagMf
 +SctdXP/Z1O73iRcWv4IcwGjcy9pwXi2d/sG1pK4SCbjsk5R5rL/98okzbeIBBLNoref
 WO0w==
X-Gm-Message-State: AOAM530ZNXwolkxZxRVo7vYKcvqk81jYlPonQsXf18/+PhwrUhh4huec
 ZGU3mCRn1FxjUmnZ7gFnzWmCiU3isNaDPwAhx6UbQvMJJ1TZhvjix/nBgfwlp+Ye/foEx3+F4Ge
 u6bEv/B+X+CCQRMbI29mHNROU
X-Received: by 2002:a50:d9cc:: with SMTP id x12mr14222027edj.44.1632914433670; 
 Wed, 29 Sep 2021 04:20:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGsZ/Prx5O98qPZ8PyofLqYoLSSiZlZikvftKjUT4ZzCknxR+J5Y+KhHMLF54Y/OqTNkUIVA==
X-Received: by 2002:a50:d9cc:: with SMTP id x12mr14221990edj.44.1632914433453; 
 Wed, 29 Sep 2021 04:20:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id l16sm1352795eds.46.2021.09.29.04.20.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Sep 2021 04:20:32 -0700 (PDT)
Message-ID: <b352c9db-6d1d-ceb9-e313-b96794f8b82f@redhat.com>
Date: Wed, 29 Sep 2021 13:20:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
To: Marcelo Tosatti <mtosatti@redhat.com>, Oliver Upton <oupton@google.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <20210928185343.GA97247@fuller.cnet>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210928185343.GA97247@fuller.cnet>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 28/09/21 20:53, Marcelo Tosatti wrote:
>> +KVM_CLOCK_HOST_TSC.  If set, the `host_tsc` field in the kvm_clock_data
>> +structure is populated with the value of the host's timestamp counter (TSC)
>> +at the instant when KVM_GET_CLOCK was called. If clear, the `host_tsc` field
>> +does not contain a value.
> If the host TSCs are not stable, then KVM_CLOCK_HOST_TSC bit (and
> host_tsc field) are ambiguous. Shouldnt exposing them be conditional on
> stable TSC for the host ?
> 

Yes, good point.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
