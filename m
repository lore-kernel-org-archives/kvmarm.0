Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03415C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 01:42:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9411A4B870;
	Mon, 12 Dec 2022 20:42:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WIE1yWwopi5c; Mon, 12 Dec 2022 20:42:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 674F04B935;
	Mon, 12 Dec 2022 20:42:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67CE44B925
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:42:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rAfA57TT5x72 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 20:42:15 -0500 (EST)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E7164B870
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:42:15 -0500 (EST)
Received: by mail-pf1-f170.google.com with SMTP id a14so1211120pfa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=opT7QlxBkoYVHWKjfFWe+3FrtkzNsO2VihRNj3rgWn4=;
 b=SK1WTnhEcJ7vOVSL2xzzXtEkHtH43rxXSGW7Dtujo2q/jDMxxwle2K41T6LEOAbu31
 njuyn58rLHAdSISg9P623gyKYXFOPbX7pgjYFQq0nCNnpQM5nUBslElHcKrZV00WUweD
 2Ab6o7XW4eUWoa8IW7OXTpjK3c5JsXSeCBMBKd1ZVWft5A67PRSXDH8qkRexDCQaB9Yn
 RRx3hIYf+BW8rjptQ0hTe+UyiZNfb7Ry3StWfXGfsaNsXjMTMnyjPwgtlBcOWZ5bOvDK
 NYZEtjUykiKNojc+IPEX89P4N1KrKqPpyt3Z0lKnKRo6M5fuKnMpjzJMGm1TZAMuI+Yh
 G8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=opT7QlxBkoYVHWKjfFWe+3FrtkzNsO2VihRNj3rgWn4=;
 b=2BvjCtSrtmgRcb8WdtMx2MCUDJ8ujPXuhGrzB69P1584Ou1mghG8XviqyDPJZv/fEr
 Uf0sNUd0mpu8NG51GRQJCuMCt39/Mj/MDYt23x5PEttYWvttEbpGvi7Q3rsBV8ll9cJN
 hHdWs5O+bkwyoZ2tM9JnrFVccb+KZgn8sVv7zzhHSTaUN1Tq7o9kIiAwGK4gLhFnlCQU
 nyUVe5dfVw9HgOI0ksZIZ/75n/02Zg3LnKOUkDZXgWCH9JOpTKxYGbNe9z5aQF/L3cZV
 PfvUtHhnqMyEgWfcGsM13onCBCG+ifj04i4OU12QDO/2gkkR9odukMFMpK0REDgvnr1S
 6G4Q==
X-Gm-Message-State: ANoB5pnJfyaxQORNajBdHdTbMTwEkBBFnPgZYVNr3TdxTfkr3SAxkYMc
 0XhAqm1DKPxoUi0jITgjtVSPCA==
X-Google-Smtp-Source: AA0mqf4Ax5/VKVlxMD5DSzFDunN/IfJNpj08Gszf3tnTB/tljXojhITyTp9EJLu9yUUGsdwIrNP7Ng==
X-Received: by 2002:a62:160a:0:b0:576:22d7:fd9e with SMTP id
 10-20020a62160a000000b0057622d7fd9emr72299pfw.0.1670895734011; 
 Mon, 12 Dec 2022 17:42:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 i134-20020a62878c000000b005761c4754e7sm6630376pfe.144.2022.12.12.17.42.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 17:42:13 -0800 (PST)
Date: Tue, 13 Dec 2022 01:42:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5fYcosbituc0kc4@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
 <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, "Amit, Nadav" <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Atish Patra <atishp@atishpatra.org>, David Matlack <dmatlack@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
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

T24gTW9uLCBEZWMgMTIsIDIwMjIsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gT24gMTIvMTIvMjIg
MTg6MzksIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4gPiBNeSBwcmVmZXJlbmNlIHdvdWxk
IGJlIHRvIGxlYXZlIC5zbW0gaW4geDg2J3MgcGFnZSByb2xlCj4gCj4gV2hhdCBhYm91dCBkZWZp
bmluZyBhIGJ5dGUgb2YgYXJjaF9yb2xlIGFuZCBhIG1hY3JvIHRvIGJ1aWxkIGl0PwoKSSB0aGlu
ayBEYXZpZCBhbHJlYWR5IGNhcnZlZCBvdXQgYSBiaWcgY2h1bmsgZm9yIGFyY2ggcm9sZSBiaXRz
LCBteSBvYmplY3Rpb24Kd2FzIHB1cmVseSB0byBtYWtpbmcgYXNfaWQgYSBnZW5lcmljIDgtYml0
IHJvbGUuCgo+ID4gVW5sZXNzIEknbSBtaXNzaW5nIHNvbWV0aGluZywgZS5nLiBhIG5lZWQgdG8g
bWFwIEdQQXMgZGlmZmVyZW50bHkgZm9yCj4gPiBTTU0gdnMuIG5vbi1TTU0sIFNNTSBjb3VsZCBo
YXZlIGJlZW4gaW1wbGVtZW50ZWQgd2l0aCBhIHNpbXBsZSBmbGFnCj4gPiBpbiBhIG1lbXNsb3Qg
dG8gbWFyayB0aGUgbWVtc2xvdCBhcyBTTU0tb25seS4KPiAKPiBVbmZvcnR1bmF0ZWx5IG5vdCwg
YmVjYXVzZSB0aGVyZSBjYW4gYmUgYW5vdGhlciByZWdpb24gKGZvciBleGFtcGxlIHZpZGVvCj4g
UkFNIGF0IDBBMDAwMGgpIHVuZGVybmVhdGggU01SQU0uCgpVZ2gsIGl0J3MgZXZlbiBhIHZlcnkg
ZXhwbGljaXRseSBkb2N1bWVudGVkICJmZWF0dXJlIi4KCiAgV2hlbiBjb21wYXRpYmxlIFNNTSBz
cGFjZSBpcyBlbmFibGVkLCBTTU0tbW9kZSBDQk8gYWNjZXNzZXMgdG8gdGhpcyByYW5nZSByb3V0
ZQogIHRvIHBoeXNpY2FsIHN5c3RlbSBEUkFNIGF0IDAwXzAwMEFfMGgg4oCTIDAwXzAwMEJfRkZG
RmguCiAgCiAgTm9uLVNNTSBtb2RlIENCTyBhY2Nlc3NlcyB0byB0aGlzIHJhbmdlIGFyZSBjb25z
aWRlcmVkIHRvIGJlIHRvIHRoZSBWaWRlbyBCdWZmZXIKICBBcmVhIGFzIGRlc2NyaWJlZCBhYm92
ZS4gUENJIEV4cHJlc3MqIGFuZCBETUkgb3JpZ2luYXRlZCBjeWNsZXMgdG8gU01NIHNwYWNlIGFy
ZSBub3QKICBzdXBwb3J0ZWQgYW5kIGFyZSBjb25zaWRlcmVkIHRvIGJlIHRvIHRoZSBWaWRlbyBC
dWZmZXIgQXJlYS4KCkkgYWxzbyBmb3Jnb3QgS1ZNIHN1cHBvcnRzIFNNQkFTRSByZWxvY2F0aW9u
IDotKAoKPiBJbiBmYWN0LCBLVk1fTUVNX1g4Nl9TTVJBTSB3YXMgdGhlIGZpcnN0IGlkZWEuICBJ
dCB3YXMgdWdsaWVyIHRoYW4gbXVsdGlwbGUKPiBhZGRyZXNzIHNwYWNlcyAoaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGttbC8xNDMxMDg0MDM0LTg0MjUtMS1naXQtc2VuZC1lbWFpbC1wYm9uemlu
aUByZWRoYXQuY29tKS4KPiBJbiByZXRyb3NwZWN0IHRoZXJlIHdlcmUgcHJvYmFibHkgd2F5cyB0
byBtaXggdGhlIGJlc3Qgb2YgdGhlIHR3byBkZXNpZ25zLAo+IGJ1dCBpdCB3YXNuJ3QgZ2VuZXJp
YyBlbm91Z2guCj4KPiA+IEFuZCBzZXBhcmF0ZSBhZGRyZXNzIHNwYWNlcyBiZWNvbWUgdHJ1bHkg
bmFzdHkgaWYgdGhlIENQVSBjYW4gYWNjZXNzIG11bHRpcGxlCj4gPiBwcm90ZWN0ZWQgcmVnaW9u
cywgZS5nLiBpZiB0aGUgQ1BVIGNhbiBhY2Nlc3MgdHlwZSBYIGFuZCB0eXBlIFkgYXQgdGhlIHNh
bWUgdGltZSwKPiA+IHRoZW4gdGhlcmUgd291bGQgbmVlZCB0byBiZSBtZW1zbG90cyBmb3IgInJl
Z3VsYXIiLCBYLCBZLCBhbmQgWCtZLgo+IAo+IFdpdGhvdXQgYSB1c2VjYXNlIHRoYXQncyBoYXJk
IHRvIHNheS4gIEl0J3MganVzdCBhcyBwb3NzaWJsZSB0aGF0IHRoZXJlCj4gd291bGQgYmUgYSBu
YXR1cmFsIGhpZXJhcmNoeSBvZiBsZXZlbHMuCgpBaCwgdHJ1ZS4KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
