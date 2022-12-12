Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45645C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 22:54:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6FE54B948;
	Mon, 12 Dec 2022 17:54:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UTvQrNigejDS; Mon, 12 Dec 2022 17:54:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 874384B947;
	Mon, 12 Dec 2022 17:54:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 847CD4B947
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:54:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yM0xZ1quHPsm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 17:54:50 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E9FC4B943
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:54:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670885689;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=A5SuLNwdZHpl5E44bqXulIn8ful04ZsB1bGOr0Kxg/E=;
 b=dJtHmLNlomH0Zh7NRab4tAY27MuMQtkHScYgM7exPx3yJz1Odna+0AleYl92lZwbAhzsix
 l6RJFKH5K4Pq+EL07KG2GFv+tNg5rBD+Vcz3Btuon/UKi5jyc1fZ8EFugIqy+nG6kAXLX/
 Pql97V0/uwd4n9ERDmoO9K27ZtXxuFY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-423-yy5lFsJOOs6aqFHnQA1ikQ-1; Mon, 12 Dec 2022 17:54:48 -0500
X-MC-Unique: yy5lFsJOOs6aqFHnQA1ikQ-1
Received: by mail-wm1-f69.google.com with SMTP id
 c126-20020a1c3584000000b003cfffcf7c1aso4764747wma.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:54:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=A5SuLNwdZHpl5E44bqXulIn8ful04ZsB1bGOr0Kxg/E=;
 b=HMcLjz4SzpeI2CY0eJWRiutzSDZ/e3dRc85Xltc3VqJ9q/o08DKAET9OWXZsTk48pi
 9m2nS20wKGog37LFn18AHjCSwPtd4cLBnXsbNLStZjc3u3IcZHV5w0zA18ZgAl/rK29t
 4uTPDkBl1NGFPVA8SFt/2Nha6HN4yQXvb+mDW9R0uImeomYJZ/M0bJvmSf1x5tewa/yh
 l1NxWFSub8rJ+cibl8pNFG3iUXUgjRHLLkYB//wMz2EpASjmQxiIkjBGJH9pXvHuopCZ
 /bsOOWgCTUzbhC2Qa30Oe9be6lFgQi3EkDeoMnOai6jB8K2zWZNCIDITUcFaPnus06iZ
 lN9g==
X-Gm-Message-State: ANoB5pkoFiHhPWLF34wO2dEBvaYeX3uESl8BEuWoss1kIE7dQHxcRWxJ
 e53CRLg+rHNK4JSxKzh1oHf1uczKvM4MvTHnXXSJSEy7tl9VPIdimMyRM3qN74d2iZaBdx6BTVG
 XrxUiDHbeQ1EzdBcVMujYEG2K
X-Received: by 2002:a05:600c:4891:b0:3d1:fbf9:3bd4 with SMTP id
 j17-20020a05600c489100b003d1fbf93bd4mr13513716wmp.10.1670885687617; 
 Mon, 12 Dec 2022 14:54:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7KvFoJFh/xdI6Uil+R/sBcLTOuYWBFn5UTZm2GDLG0lMDUVKnPmisnw/N8nz6QJ1gfZ6zvaw==
X-Received: by 2002:a05:600c:4891:b0:3d1:fbf9:3bd4 with SMTP id
 j17-20020a05600c489100b003d1fbf93bd4mr13513681wmp.10.1670885687379; 
 Mon, 12 Dec 2022 14:54:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 h7-20020a05600c314700b003cfd4a50d5asm12200704wmo.34.2022.12.12.14.54.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 14:54:46 -0800 (PST)
Message-ID: <eb93beee-9d43-1c1e-250c-28ab7e9ebed9@redhat.com>
Date: Mon, 12 Dec 2022 23:54:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Oliver Upton <oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <Y5OHVzBSHPmAq2FO@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
In-Reply-To: <Y5OHVzBSHPmAq2FO@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, xu xin <cgel.zte@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 Colin Cross <ccross@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTIvOS8yMiAyMDowNywgT2xpdmVyIFVwdG9uIHdyb3RlOgo+PiAgIC0gTmFtaW5nLiBUaGlz
IHNlcmllcyBkb2VzIG5vdCBjaGFuZ2UgdGhlIG5hbWVzIG9mIGFueSBleGlzdGluZyBjb2RlLgo+
PiAgICAgU28gYWxsIHRoZSBLVk0veDg2IFNoYWRvdyBNTVUtc3R5bGUgdGVybWlub2xvZ3kgbGlr
ZQo+PiAgICAgInNoYWRvd19wYWdlIi8ic3AiLyJzcHRlIiBwZXJzaXN0cy4gU2hvdWxkIHdlIGtl
ZXAgdGhhdCBzdHlsZSBpbgo+PiAgICAgY29tbW9uIGNvZGUgb3IgbW92ZSB0b3dhcmQgc29tZXRo
aW5nIGxlc3Mgc2hhZG93LXBhZ2luZy1zcGVjaWZpYz8KPj4gICAgIGUuZy4gInBhZ2VfdGFibGUi
LyJwdCIvInB0ZSIuCj4KPiBJIHdvdWxkIHN0cm9uZ2x5IGJlIGluIGZhdm9yIG9mIGRpc2NhcmRp
bmcgdGhlIHNoYWRvdyBwYWdpbmcgcmVzaWR1ZSBpZgo+IHg4NiBmb2xrcyBhcmUgd2lsbGluZyB0
byBwYXJ0IHdheXMgd2l0aCBpdCDwn5iECgpZZXMsIGFic29sdXRlbHkuICBTb21ldGhpbmcgbGlr
ZSB0b19zaGFkb3dfcGFnZS0+dG9fbW11X2RhdGEsIHNwLT5tZCwgCnNwdC0+aHB0LCBzcHRlLT5z
cHRlLCBzcHRlcC0+aHB0ZXAuCgpQYW9sbwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
