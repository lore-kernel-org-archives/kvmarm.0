Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF717C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 11:12:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33FB62075A
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 11:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="idRFm5i3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33FB62075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9972E4B215;
	Fri, 29 May 2020 07:12:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RhZ+Wg7YTYlL; Fri, 29 May 2020 07:12:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 889D34B216;
	Fri, 29 May 2020 07:12:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FBDD4B213
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 07:12:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nJWgxDwtFVtq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 07:12:04 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6114B199
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 07:12:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590750724;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9M/dfx/AlUONwh5MphhAji3d3cM3kUpcCH4+D+us/Ew=;
 b=idRFm5i3M/WwMQ7w8LdlYfRBby0mYNOGXhRvwghoUlvTN3u420xC3NUAKNd8+znvFkHbjy
 YfUEcIDKznk2z/N+hgpBPV9ofgRp8XEPlK/sgMvxQ+VdUvofqbkey8HeCtgVa885Crthnv
 lFbqLj3qqEoXqg3UePMbpAhcIpNyA4I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-BBQB2GP5Pq6Sq-xV66sQXA-1; Fri, 29 May 2020 07:12:02 -0400
X-MC-Unique: BBQB2GP5Pq6Sq-xV66sQXA-1
Received: by mail-wr1-f72.google.com with SMTP id z10so921845wrs.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 04:12:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=9M/dfx/AlUONwh5MphhAji3d3cM3kUpcCH4+D+us/Ew=;
 b=uBHXBgrZm3nrMM172wQjUKuPC8mIYlhZbXkAES9P6KwUSsSAPZuw/8veNkytRSIkJ3
 I3LKnJWv3FUYf4lgDV3rFVrhPYTEjy03MDlj7BpbsMqeMkfZTbfA48CaxKmKMHgoJx3k
 u75UBC0Rr5JmLAZGw7lanyogV1duglC00OHlfv2VgSmvAnn2A6NuTpaQlw9njNFhtKfT
 te/+B46sz3XZvGR6SNjUxGFIdb2OOHjzqrsgjCNGnS3cvVE+B7d2pYWC2m9Xmj8ugI7A
 SGpZeMSgRuftB7oiF0AXdtYBkG7KhnOkdXnW143SyRxniDe9AgoCpaehQOu4xFnrnT31
 048A==
X-Gm-Message-State: AOAM531kqHSWIRcf/vIJrmHri1FzseGdu+cGdX9L42GigrA53spbGjYM
 zbjMVcUAPfCcNVfJvMWzrQYyRxc9m+CxsGAuU5kwKNlCayVi5bu9D95e8QuC4gLPQl0hkgy6VEn
 dQtG2evV46PRpk9DUX1ZQO00/
X-Received: by 2002:a7b:c5cc:: with SMTP id n12mr8037156wmk.69.1590750720111; 
 Fri, 29 May 2020 04:12:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXn3TKEVztYoQ/UzuKg90zh74+FaWzUOHiQ5op3FdCYq5th45LuGb7iOizyYyyR3rfbSOLuQ==
X-Received: by 2002:a7b:c5cc:: with SMTP id n12mr8037141wmk.69.1590750719880; 
 Fri, 29 May 2020 04:11:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7?
 ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
 by smtp.gmail.com with ESMTPSA id t8sm9309944wro.56.2020.05.29.04.11.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 29 May 2020 04:11:59 -0700 (PDT)
Subject: Re: [PATCH RFCv2 9/9] arm64: Support async page fault
To: Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-10-gshan@redhat.com>
 <81adf013-3de7-23e6-7648-8aec821b033c@redhat.com>
 <a6addc25-29af-3690-8392-efa5e8381e98@redhat.com>
 <8ab64c6a-582b-691d-79ab-21cdc0455cd3@redhat.com>
 <6a4a82a4-af01-98c2-c854-9199f55f7bd3@redhat.com>
 <6965aaf641a23fab64fbe2ceeb790272@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d0bfb944-b50a-608a-7dcc-5a409cdc4524@redhat.com>
Date: Fri, 29 May 2020 13:11:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6965aaf641a23fab64fbe2ceeb790272@kernel.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 29/05/20 11:41, Marc Zyngier wrote:
>>>
>>>
>>> For x86 the advantage is that the processor can take care of raising the
>>> stage2 page fault in the guest, so it's faster.
>>>
>> I think there might be too much overhead if the page can be populated
>> quickly by host. For example, it's fast to populate the pages if swapin
>> isn't involved.

Those would still be handled by the host.  Only those that are not
present in the host (which you can see through the MMU notifier) would
be routed to the guest.  You can do things differently between "not
present fault because the page table does not exist" and "not present
fault because the page is missing in the host".

>> If I'm correct enough, it seems arm64 doesn't have similar mechanism,
>> routing stage2 page fault to guest.
> 
> Indeed, this isn't a thing on arm64. Exception caused by a S2 fault are
> always routed to EL2.

Is there an ARM-approved way to reuse the S2 fault syndromes to detect
async page faults?

(By the way, another "modern" use for async page faults is for postcopy
live migration).

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
