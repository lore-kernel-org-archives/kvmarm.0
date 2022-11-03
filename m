Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0174C4167B
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88EFA4B269;
	Thu,  3 Nov 2022 12:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xoBRn3sCJxpx; Thu,  3 Nov 2022 12:58:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69A324B6EE;
	Thu,  3 Nov 2022 12:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14BFA4B653
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:16:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T52-cJMjrR4S for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 03:16:53 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8FED4B640
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:16:53 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id
 m7-20020a05600c090700b003cf8a105d9eso535877wmp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 00:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=hhVVFU4gv+0KPdkJhZ6Bsgp0nMXVzSegBp2GVEhxHuI=;
 b=h9I23FTp6GIOXmio03YkEg/XABkIyK7okfyOacacDCySEptlxLcYcKstMetIpqEjVI
 AJxxtkE/wdXbgKxacBRTI0vKPMD7Lrwttr/WvlHH6ej0kR33MU05lAqiRuHOXS6eYgUi
 5D/WB/7tpxiogfi3huBIVAcoj+aw5jR0iw+raivB9st+zpUrHhjUaefLK8xl1XeXGROT
 jIYtNJVpBXb1lhi22kZeWS2z2s2scGKIObYA8G99yKRsKrD7Waw2HL3AJk86rNi+kcwk
 ldYfFW2HEUS0Ngd3K7BW6C8SpUqOYnm44amyRmlRCLpiKmxp0dOvOZKAUgifFtw1/6bS
 zu8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=hhVVFU4gv+0KPdkJhZ6Bsgp0nMXVzSegBp2GVEhxHuI=;
 b=SHr3D62YdK9CT2Nl47R8ftfdOT6m/xPcHaGqfIUVAzADOgWL67XFB3jdQNxDEo+FCB
 /vh9oRZ3U16QHzORAYP+SbNc/QWXC0aM1LAHAzu9uZ89LsHts5fKnzXg4w+0CHa497Tv
 sRE0fcK2NiYdyKxspc2BFn789YtGXnNMB4Wb1IA3hKB21a8JcjY1o8oQPmQxd/z1Tqb5
 nI95D9FZJOGmaW/VoWcIp+BxxCYz8WUXjb4lrER5q3oE7sgfu5/m4iQLhaciXW5ueMYb
 Iu3DAwXNVRjOIVSkgIQGhRM3IdUXLduGKPTo1CP1yQSmNu9jd9rZeZiEeROShw3Sav9Q
 8vKA==
X-Gm-Message-State: ACrzQf2uDxtAlQ9W6IG7vH1/DcmwDuQQRdarghY2hms9HPAB0nMKBs56
 KsK9C3wxXyckN+3bcSLApIhbMA==
X-Google-Smtp-Source: AMsMyM5U5tWVDdkP8vx2CGlIc4Tyh8xELM0VfMzpr/hFq4D4kTE8+riEzXzUJzEDmk/itTcMkiPp1A==
X-Received: by 2002:a05:600c:22c6:b0:3cf:88bb:3a95 with SMTP id
 6-20020a05600c22c600b003cf88bb3a95mr4075812wmg.71.1667459812670; 
 Thu, 03 Nov 2022 00:16:52 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net.
 [88.29.181.216]) by smtp.gmail.com with ESMTPSA id
 p22-20020a05600c359600b003c6b9749505sm4601041wmq.30.2022.11.03.00.16.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 00:16:51 -0700 (PDT)
Message-ID: <5aaa19b8-da75-9a3c-634b-d4c26f77943b@linaro.org>
Date: Thu, 3 Nov 2022 08:16:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 25/44] KVM: s390: Do s390 specific init without bouncing
 through kvm_init()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-26-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-26-seanjc@google.com>
X-Mailman-Approved-At: Thu, 03 Nov 2022 12:58:44 -0400
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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

T24gMy8xMS8yMiAwMDoxOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBNb3ZlIHRoZSBn
dXRzIG9mIGt2bV9hcmNoX2luaXQoKSBpbnRvIGEgbmV3IGhlbHBlciwgX19rdm1fczM5MF9pbml0
KCksCj4gYW5kIGludm9rZSB0aGUgbmV3IGhlbHBlciBkaXJlY3RseSBmcm9tIGt2bV9zMzkwX2lu
aXQoKSBpbnN0ZWFkIG9mCj4gYm91bmNpbmcgdGhyb3VnaCBrdm1faW5pdCgpLiAgSW52b2tpbmcg
a3ZtX2FyY2hfaW5pdCgpIGlzIHRoZSB2ZXJ5Cj4gZmlyc3QgYWN0aW9uIHBlcmZvcm1lZCBieSBr
dm1faW5pdCgpLCBpLmUuIHRoaXMgaXMgYSBnbG9yaWZpZWQgbm9wLgo+IAo+IE1vdmluZyBzZXR1
cCB0byBfX2t2bV9zMzkwX2luaXQoKSB3aWxsIGFsbG93IHRhZ2dpbmcgbW9yZSBmdW5jdGlvbnMg
YXMKPiBfX2luaXQsIGFuZCBlbXB0eWluZyBrdm1fYXJjaF9pbml0KCkgd2lsbCBhbGxvdyBkcm9w
cGluZyB0aGUgaG9vawo+IGVudGlyZWx5IG9uY2UgYWxsIGFyY2hpdGVjdHVyZSBpbXBsZW1lbnRh
dGlvbnMgYXJlIG5vcHMuCj4gCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuCj4gCj4g
U2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+Cj4g
LS0tCj4gICBhcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMgfCAyOSArKysrKysrKysrKysrKysrKysr
KysrKysrLS0tLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pCgpSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5h
cm8ub3JnPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
