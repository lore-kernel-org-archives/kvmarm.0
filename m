Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36DFC4167E
	for <kvmarm@archiver.kernel.org>; Tue,  8 Nov 2022 05:44:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 115134B8C9;
	Tue,  8 Nov 2022 00:44:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HzGQY2V-YbvX; Tue,  8 Nov 2022 00:43:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C79464B8CA;
	Tue,  8 Nov 2022 00:43:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0EA64B8C6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 00:43:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JRp2LyOlk0cI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 00:43:56 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DBB14B8C5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 00:43:56 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id io19so13227587plb.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 21:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=3UicMHRBXNKZ6klzBYtNlGfdpT3ipHtBcp9O7LuoFbE=;
 b=XNdeC13pb4LjOBaRWcKMBNqFRJ+RgsbfVoNw18z5L+vfkg1SZceZjUxbLhiIy1qySy
 Y4hI02da8j9ev8qt2sUsGeUiOSLlDAUgz5JUplPGm8kAk4jLtNdmDFZCCStM1EGIelNU
 pjjtL4FSGAVwgisQucoSj4vLVpkgLqzZdzX9wYytiy3sfYNB3aYKj8S/Nug5gaKAa8gA
 /5oDb+KCNmSa3bC/jNyCQmeij+quPN3cyVSSr1ovXCPVJxrqYAAydTsm3Q4bRt6yNhxm
 6FVSyKTuVZN23UWZkdV6Uc7djgZpboRwjQPImKvKrchYImM3eB6pVBMtJk1jJ8Nfk6ob
 kIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=3UicMHRBXNKZ6klzBYtNlGfdpT3ipHtBcp9O7LuoFbE=;
 b=kXXHLvT/UIkLM9YSnn1YN/mNjTd8SctGVJwGJgMiWsk/cjLOgiyjqiu+9RoiXWi6IT
 CF5dNvpuSpgUvnkP6yk++a5aIkmbIxHEyQg4I1l5hnSA54/gkB+5BL3mGsU5/axHgSdS
 wLYZqNDlu9pXXNNSYfV+LuvyVZ1tNKJS8R2xF6k2OtaFKKUqGGHG++MxZM1PTkgPSnT7
 S5Bl2wLlI6yUPEZUz8nGqcUpq7fJU2i3zVtgJr6CPG76npic7zpOf8vgq648tgOBQPZr
 4weoyC6UYlVDiLx+nXi2w/ICZNagsXwYguVD3wAbjV8wSiaCk7TFMnKHGe/2t8+aCZ3x
 FBzQ==
X-Gm-Message-State: ACrzQf21o8DBHItMIte+Z/AGJdkIuuhazsOvsr9hxgS7Q99Ngahx3PXx
 ps+7kF0stU1RlVNUaRiS0gY=
X-Google-Smtp-Source: AMsMyM6Ssf7qu6Zt1cmqzeY+6ksfJF4jyx1t2euaZBhwzvq5JPVY+8zsaODdG48vWXQYQDWTdtSyvw==
X-Received: by 2002:a17:90b:4a04:b0:213:587b:204e with SMTP id
 kk4-20020a17090b4a0400b00213587b204emr55088612pjb.98.1667886235549; 
 Mon, 07 Nov 2022 21:43:55 -0800 (PST)
Received: from localhost ([192.55.54.55]) by smtp.gmail.com with ESMTPSA id
 k21-20020a628415000000b0056bb06ce1cfsm5614872pfd.97.2022.11.07.21.43.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 21:43:55 -0800 (PST)
Date: Mon, 7 Nov 2022 21:43:54 -0800
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Message-ID: <20221108054354.GA1708572@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
 <Y2V1oslbw24/2Opd@google.com>
 <20221107214634.GE1063309@ls.amr.corp.intel.com>
 <bf29fe1ac84cae8ddb06e566b56c653600a1901c.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bf29fe1ac84cae8ddb06e566b56c653600a1901c.camel@intel.com>
Cc: "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "david@redhat.com" <david@redhat.com>,
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "Gao,
 Chao" <chao.gao@intel.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "Yao,
 Yuan" <yuan.yao@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "frankja@linux.ibm.com" <frankja@linux.ibm.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>,
 "atishp@atishpatra.org" <atishp@atishpatra.org>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
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

T24gVHVlLCBOb3YgMDgsIDIwMjIgYXQgMDE6MDk6MjdBTSArMDAwMCwKIkh1YW5nLCBLYWkiIDxr
YWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToKCj4gT24gTW9uLCAyMDIyLTExLTA3IGF0IDEzOjQ2
IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToKPiA+ID4gT24gRnJpLCBOb3YgMDQsIDIwMjIs
IElzYWt1IFlhbWFoYXRhIHdyb3RlOgo+ID4gPiA+IFRoYW5rcyBmb3IgdGhlIHBhdGNoIHNlcmll
cy4gSSB0aGUgcmViYXNlZCBURFggS1ZNIHBhdGNoIHNlcmllcyBhbmQgaXQKPiA+ID4gPiB3b3Jr
ZWQuCj4gPiA+ID4gU2luY2UgY3B1IG9mZmxpbmUgbmVlZHMgdG8gYmUgcmVqZWN0ZWQgaW4gc29t
ZSBjYXNlcyhUbyBrZWVwIGF0IGxlYXN0IG9uZQo+ID4gPiA+IGNwdQo+ID4gPiA+IG9uIGEgcGFj
a2FnZSksIGFyY2ggaG9vayBmb3IgY3B1IG9mZmxpbmUgaXMgbmVlZGVkLgo+ID4gPiAKPiA+ID4g
SSBoYXRlIHRvIGJyaW5nIHRoaXMgdXAgYmVjYXVzZSBJIGRvdWJ0IHRoZXJlJ3MgYSByZWFsIHVz
ZSBjYXNlIGZvciBTVVNQRU5ECj4gPiA+IHdpdGgKPiA+ID4gVERYLCBidXQgdGhlIENQVSBvZmZs
aW5lIHBhdGggaXNuJ3QganVzdCBmb3IgdHJ1ZSBvZmZsaW5pbmcgb2YgQ1BVcy7CoCBXaGVuCj4g
PiA+IHRoZQo+ID4gPiBzeXN0ZW0gZW50ZXJzIFNVU1BFTkQsIG9ubHkgdGhlIGluaXRpYXRpbmcg
Q1BVIGdvZXMgdGhyb3VnaAo+ID4gPiBrdm1fc3VzcGVuZCgpK2t2bV9yZXN1bWUoKSwKPiA+ID4g
YWxsIHJlc3BvbmRpbmcgQ1BVcyBnbyB0aHJvdWdoIENQVSBvZmZsaW5lK29ubGluZS7CoCBJLmUu
IGRpc2FsbG93aW5nIGFsbAo+ID4gPiBDUFVzIGZyb20KPiA+ID4gZ29pbmcgIm9mZmxpbmUiIHdp
bGwgcHJldmVudCBzdXNwZW5kaW5nIHRoZSBzeXN0ZW0uCj4gPiAKPiA+IFRoZSBjdXJyZW50IFRE
WCBLVk0gaW1wbGVtZW50YXRpb24gZGlzYWxsb3dzIENQVSBwYWNrYWdlIGZyb20gb2ZmbGluZSBv
bmx5Cj4gPiB3aGVuCj4gPiBURHMgYXJlIHJ1bm5pbmcuwqAgSWYgbm8gVEQgaXMgcnVubmluZywg
Q1BVIG9mZmxpbmUgaXMgYWxsb3dlZC7CoCBTbyBiZWZvcmUKPiA+IFNVU1BFTkQsIFREcyBuZWVk
IHRvIGJlIGtpbGxlZCB2aWEgc3lzdGVtZCBvciBzb21ldGhpbmcuwqAgQWZ0ZXIga2lsbGluZyBU
RHMsCj4gPiB0aGUKPiA+IHN5c3RlbSBjYW4gZW50ZXIgaW50byBTVVNQRU5EIHN0YXRlLgo+IAo+
IFRoaXMgc2VlbXMgbm90IGNvcnJlY3QuICBZb3UgbmVlZCBvbmUgY3B1IGZvciBlYWNoIHRvIGJl
IG9ubGluZSBpbiBvcmRlciB0bwo+IGNyZWF0ZSBURCBhcyB3ZWxsLCBhcyBUREguTU5HLktFWS5D
T05GSUcgbmVlZHMgdG8gYmUgY2FsbGVkIG9uIGFsbCBwYWNrYWdlcywKPiBjb3JyZWN0PwoKVGhh
dCdzIGNvcnJlY3QuIEluIHN1Y2ggY2FzZSwgdGhlIGNyZWF0aW9uIG9mIFREIGZhaWxzLiAgVEQg
Y3JlYXRpb24gY2hlY2tzIGlmCmF0IGxlYXN0IG9uZSBjcHUgaXMgb25saW5lIG9uIGFsbCBDUFUg
cGFja2FnZXMuICBJZiBubywgZXJyb3IuCi0tIApJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhh
dGFAZ21haWwuY29tPgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
