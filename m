Return-Path: <SRS0=/xnR=7K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E572C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 10:49:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84855207D3
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 10:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="daarYCrs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84855207D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B11384B206;
	Thu, 28 May 2020 06:49:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5dIPK4hYeApF; Thu, 28 May 2020 06:49:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A65AA4B20D;
	Thu, 28 May 2020 06:49:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD4C4B206
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 06:48:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R3zSx4mldweo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 06:48:58 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A06A84B205
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 06:48:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590662938;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VSHyppY1XpO/9eGOXVmynSt7C5Mi1ApHOoRfoxA27gc=;
 b=daarYCrsRCMDh9yzzE2jH3N0sdimDMLmj5cWxkF25TLQK3sGAG8sCmL+v+jVR99POQQxRu
 LjInRUTsCNEzD1HsJ1dbIpw/ZOUKnpXlo88QgqE5kBYZj/gXqCCwEWBumJTs/CJJ5I0vSl
 yTO+oG2xvJTjXKj2L6z6x7+vt1lZzhU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-d_ZBLD0PPyy_st3t2b5AFQ-1; Thu, 28 May 2020 06:48:56 -0400
X-MC-Unique: d_ZBLD0PPyy_st3t2b5AFQ-1
Received: by mail-ej1-f72.google.com with SMTP id ng1so9996314ejb.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 03:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=VSHyppY1XpO/9eGOXVmynSt7C5Mi1ApHOoRfoxA27gc=;
 b=KyaL3AfXizwzLjPTBsJngNuY3y/QsagoJC2Nk311QIF7HbMpACJq5LumLgXTYExwYN
 41b31D/4f9jRET17sPdQoUIh8O9ASH7KbvzGMGL/SOIhLnNmcQ3lEkOuA9QxErEC3ZKa
 aDkHCnO4pFU8necQEyn2CQwjrYe3dgALHj79B3N4CCyIvwzo7ZJDWbcE332VdxVXTZXP
 k4dCokNL4sOW6QHHe6B/LZ8ECRdO6eGQKTzYDHp8ZaNlx/CPwDmN0vdSiQ6RSnE39pJH
 V9ikwczvYhKv4S6PGeef9n++Tha5GMPMsmvkMSxRX6lLHU3g9MlDcJ3zpXY5lJAvCXNN
 VKug==
X-Gm-Message-State: AOAM532v1dX2nKqFF2rmIENJfhoq8TJFmuM21iqo27uZe5ASG/ZmM5Md
 uztv6C4gpDZDw+cX1e+jW5BXtukU1by0TjeL44jHhluvi5TEwOJ/yidPW4gMf1t7sopBRGGov+/
 ebxjYLory22Ch4sJVXMZD10vo
X-Received: by 2002:a17:906:a0c2:: with SMTP id
 bh2mr2342896ejb.406.1590662935606; 
 Thu, 28 May 2020 03:48:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFdxMkqeLHcH4ajH7tF56oPdNndquNFDl+4l5rFf/cP02xjCMi5+crYKrNqwLkTxQeEQjKEg==
X-Received: by 2002:a17:906:a0c2:: with SMTP id
 bh2mr2342873ejb.406.1590662935381; 
 Thu, 28 May 2020 03:48:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8?
 ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
 by smtp.gmail.com with ESMTPSA id o21sm4709127edr.68.2020.05.28.03.48.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 May 2020 03:48:54 -0700 (PDT)
Subject: Re: [PATCH RFCv2 9/9] arm64: Support async page fault
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-10-gshan@redhat.com>
 <81adf013-3de7-23e6-7648-8aec821b033c@redhat.com>
 <a6addc25-29af-3690-8392-efa5e8381e98@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ab64c6a-582b-691d-79ab-21cdc0455cd3@redhat.com>
Date: Thu, 28 May 2020 12:48:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a6addc25-29af-3690-8392-efa5e8381e98@redhat.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjgvMDUvMjAgMDg6MTQsIEdhdmluIFNoYW4gd3JvdGU6Cj4+IC0gZm9yIHg4NiB3ZSdyZSBh
bHNvIHRoaW5raW5nIG9mIGluaXRpYXRpbmcgdGhlIHBhZ2UgZmF1bHQgZnJvbSB0aGUKPj4gZXhj
ZXB0aW9uIGhhbmRsZXIsIHJhdGhlciB0aGFuIGRvaW5nIHNvIGZyb20gdGhlIGh5cGVydmlzb3Ig
YmVmb3JlCj4+IGluamVjdGluZyB0aGUgZXhjZXB0aW9uLsKgIElmIEFSTSBsZWFkcyB0aGUgd2F5
IGhlcmUsIHdlIHdvdWxkIGRvIG91cgo+PiBiZXN0IHRvIHNoYXJlIGNvZGUgd2hlbiB4ODYgZG9l
cyB0aGUgc2FtZS4KPiAKPiBTb3JyeSwgUGFvbG8sIEkgZG9uJ3QgZm9sbG93IHlvdXIgaWRlYSBo
ZXJlLiBDb3VsZCB5b3UgcGxlYXNlIHByb3ZpZGUKPiBtb3JlIGRldGFpbHM/CgpUaGUgaWRlYSBp
cyB0byBpbmplY3Qgc3RhZ2UyIHBhZ2UgZmF1bHRzIGludG8gdGhlIGd1ZXN0IGV2ZW4gYmVmb3Jl
IHRoZQpob3N0IHN0YXJ0cyBwb3B1bGF0ZXMgdGhlIHBhZ2UuICBUaGUgZ3Vlc3QgdGhlbiBpbnZv
a2VzIGEgaHlwZXJjYWxsLAp0ZWxsaW5nIHRoZSBob3N0IHRvIHBvcHVsYXRlIHRoZSBwYWdlIHRh
YmxlIGFuZCBpbmplY3QgdGhlICdwYWdlIHJlYWR5JwpldmVudCAoaW50ZXJydXB0KSB3aGVuIGl0
J3MgZG9uZS4KCkZvciB4ODYgdGhlIGFkdmFudGFnZSBpcyB0aGF0IHRoZSBwcm9jZXNzb3IgY2Fu
IHRha2UgY2FyZSBvZiByYWlzaW5nIHRoZQpzdGFnZTIgcGFnZSBmYXVsdCBpbiB0aGUgZ3Vlc3Qs
IHNvIGl0J3MgZmFzdGVyLgoKUGFvbG8KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
