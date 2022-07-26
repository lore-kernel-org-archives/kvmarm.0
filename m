Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63C0C00144
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 15:33:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23C8C4C730;
	Tue, 26 Jul 2022 11:33:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BGzSbaFle6Mb; Tue, 26 Jul 2022 11:33:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 173184C739;
	Tue, 26 Jul 2022 11:33:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4894C730
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 11:33:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tKFuxEDRYzm9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 11:33:33 -0400 (EDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 523AD4C72E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 11:33:33 -0400 (EDT)
Received: by mail-wr1-f47.google.com with SMTP id k11so20228950wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 08:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=IdrmtKsVwJ8Ilm8fXdlZo1ojDSarLxj4cwD1+3jZZEk=;
 b=OqCNg3Evlo5tkojw6+O9gMzqKRS/81Ng74vt1BFuMXIRVoj+ueOPnewIymEDcvNbsA
 GrTelS4phLivi2uHD1PHTtXKp55HSg8TUI748XhWMdrJm28oIfHDx/WkiAjZW46k57+x
 6YmtHrQsq3VmBUk04cYdjOmWJ8j7Sn6Ug1slr8XmG3pngkPHXku6peewmEPuAuktdRnZ
 b5R+MxAoh0AnJ92YiuB+1nQKotCBa3cjPKqGeivWHwO8U9tBjdLyahbAc+YDhK91MBD2
 pcMCrC+ezfRpRQBGbbQejnVCyDmZ601SYHCW9NZAVK7zw5uy7vtWyqttX0N4761Z8Bkx
 bkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=IdrmtKsVwJ8Ilm8fXdlZo1ojDSarLxj4cwD1+3jZZEk=;
 b=vRh8ZoKP1ICTpKLeck36M5sbmq94CK6FnAUhaR+J1zYgCy+bq814O07CCpEpxztjQQ
 f/3Ri8upeBnm+nDwG+m+pAy6ygspvY0kAFolRGvXFN2cROcI/qGB+8OavpKi0ElV4mPf
 b/1r13aNtD5Dkq7LmKLQbh4kzTd7y6DkPhYJ6RZXUaeWgKQYlqwa29wn7ovlt/phfuxK
 jq4Gc3O/9WkhGVMmncP9spsJQJOmk7R96BHcUhR2twaz4YHDIDvGnzk7wgE2NZh9Y3GB
 PYIDUoJGqop4IlwahyY+h02CX8IVqNBie3UglprbqLMPrvI8Jz9+zbG0pztAwfbIvIOC
 Yi7g==
X-Gm-Message-State: AJIora+yVFBWLJRqYLdptdwd4AMVGCWsr3zFksFW6FUwbtuc3kaLL4Gb
 j7Q8kI8MIhqxqXjjnzF+tHZ+uY2knHL1hzjCgdIBkA==
X-Google-Smtp-Source: AGRyM1sEa6iMPu3EBWOW+qgWlSZBYXUn6OljA5SeoAQuOFG/BP2IVZ12GTJ9KaYjd799UK0R/24QNFygZopnAgNFRrY=
X-Received: by 2002:a5d:4583:0:b0:21e:3b0e:2bc9 with SMTP id
 p3-20020a5d4583000000b0021e3b0e2bc9mr11226482wrq.649.1658849612164; Tue, 26
 Jul 2022 08:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
 <20220726073750.3219117-13-kaleshsingh@google.com>
 <87a68wxkga.wl-maz@kernel.org>
In-Reply-To: <87a68wxkga.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 26 Jul 2022 08:33:20 -0700
Message-ID: <CAC_TJve+33nTGNVZrsnrEJGPGMvCNARougeSmXWDdjiq_Daeig@mail.gmail.com>
Subject: Re: [PATCH v6 12/17] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 android-mm@google.com, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>, Marco Elver <elver@google.com>,
 Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, andreyknvl@gmail.com,
 LKML <linux-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>
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

T24gVHVlLCBKdWwgMjYsIDIwMjIgYXQgMzowMCBBTSBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPiB3cm90ZToKPgo+IE9uIFR1ZSwgMjYgSnVsIDIwMjIgMDg6Mzc6NDUgKzAxMDAsCj4gS2Fs
ZXNoIFNpbmdoIDxrYWxlc2hzaW5naEBnb29nbGUuY29tPiB3cm90ZToKPiA+Cj4gPiBUaGlzIGNh
biBiZSB1c2VkIHRvIGRpc2FibGUgc3RhY2t0cmFjZSBmb3IgdGhlIHByb3RlY3RlZCBLVk0KPiA+
IG5WSEUgaHlwZXJ2aXNvciwgaW4gb3JkZXIgdG8gc2F2ZSBvbiB0aGUgYXNzb2NpYXRlZCBtZW1v
cnkgdXNhZ2UuCj4gPgo+ID4gVGhpcyBvcHRpb24gaXMgZGlzYWJsZWQgYnkgZGVmYXVsdCwgc2lu
Y2UgcHJvdGVjdGVkIEtWTSBpcyBub3Qgd2lkZWx5Cj4gPiB1c2VkIG9uIHBsYXRmb3JtcyBvdGhl
ciB0aGFuIEFuZHJvaWQgY3VycmVudGx5Lgo+ID4KPiA+IFNpZ25lZC1vZmYtYnk6IEthbGVzaCBT
aW5naCA8a2FsZXNoc2luZ2hAZ29vZ2xlLmNvbT4KPiA+IFJldmlld2VkLWJ5OiBGdWFkIFRhYmJh
IDx0YWJiYUBnb29nbGUuY29tPgo+ID4gVGVzdGVkLWJ5OiBGdWFkIFRhYmJhIDx0YWJiYUBnb29n
bGUuY29tPgo+ID4gLS0tCj4gPgo+ID4gQ2hhbmdlcyBpbiB2NjoKPiA+ICAgLSBBZGQgRnVhZOKA
mXMgUmV2aWV3ZWQtYnkgYW5kIFRlc3RlZC1ieSB0YWdzCj4gPgoKPiA+IENoYW5nZXMgaW4gdjU6
Cj4gPiAgIC0gTWFrZSBQUk9URUNURURfTlZIRV9TVEFDS1RSQUNFIGRlcGVuZCBvbiBOVkhFX0VM
Ml9ERUJVRywgcGVyIE1hcmMKPiA+Cj4gPiAgYXJjaC9hcm02NC9rdm0vS2NvbmZpZyB8IDE1ICsr
KysrKysrKysrKysrKwo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspCj4gPgo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL0tjb25maWcgYi9hcmNoL2FybTY0L2t2bS9L
Y29uZmlnCj4gPiBpbmRleCA4YTVmYmJmMDg0ZGYuLjA5Yzk5NTg2OTkxNiAxMDA2NDQKPiA+IC0t
LSBhL2FyY2gvYXJtNjQva3ZtL0tjb25maWcKPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL0tjb25m
aWcKPiA+IEBAIC00Niw2ICs0NiwyMSBAQCBtZW51Y29uZmlnIEtWTQo+ID4KPiA+ICAgICAgICAg
SWYgdW5zdXJlLCBzYXkgTi4KPiA+Cj4gPiArY29uZmlnIFBST1RFQ1RFRF9OVkhFX1NUQUNLVFJB
Q0UKPiA+ICsgICAgIGJvb2wgIlByb3RlY3RlZCBLVk0gaHlwZXJ2aXNvciBzdGFja3RyYWNlcyIK
PiA+ICsgICAgIGRlcGVuZHMgb24gTlZIRV9FTDJfREVCVUcKPiA+ICsgICAgIGRlZmF1bHQgbgo+
ID4gKyAgICAgaGVscAo+ID4gKyAgICAgICBTYXkgWSBoZXJlIHRvIGVuYWJsZSBwS1ZNIGh5cGVy
dmlzb3Igc3RhY2t0cmFjZXMgb24gaHlwX3BhbmljKCkKPiA+ICsKPiA+ICsgICAgICAgSWYgeW91
IGFyZSBub3QgdXNpbmcgcHJvdGVjdGVkIG5WSEUgKHBLVk0pLCBzYXkgTi4KPiA+ICsKPiA+ICsg
ICAgICAgSWYgdXNpbmcgcHJvdGVjdGVkIG5WSEUgbW9kZSwgYnV0IGNhbm5vdCBhZmZvcmQgdGhl
IGFzc29jaWF0ZWQKPiA+ICsgICAgICAgbWVtb3J5IGNvc3QgKGxlc3MgdGhhbiAwLjc1IHBhZ2Ug
cGVyIENQVSkgb2YgcEtWTSBzdGFja3RyYWNlcywKPiA+ICsgICAgICAgc2F5IE4uCj4gPiArCj4g
PiArICAgICAgIElmIHVuc3VyZSwgc2F5IE4uCj4gPiArCj4gPiAgY29uZmlnIE5WSEVfRUwyX0RF
QlVHCj4gPiAgICAgICBib29sICJEZWJ1ZyBtb2RlIGZvciBub24tVkhFIEVMMiBvYmplY3QiCj4g
PiAgICAgICBkZXBlbmRzIG9uIEtWTQo+Cj4gSGF2aW5nIE5WSEVfRUwyX0RFQlVHIGFmdGVyIFBS
T1RFQ1RFRF9OVkhFX1NUQUNLVFJBQ0UgaXMgcHJldHR5IG9kZAo+IHdoZW4geW91IHVzZSAnbWFr
ZSBtZW51Y29uZmlnJywgYXMgdGhlIG5ldyBvcHRpb24gYXBwZWFycyBvdXQgb2YKPiBzZXF1ZW5j
ZS4KCkFoaCBnb29kIGNhdGNoLiBTaG91bGQgaGF2ZSBtb3ZlZCBpdCB3aGVuIHRoZSBkZXBlbmRl
bmN5IGdvdCBjaGFuZ2VkLgoKPgo+IEknbGwgbW92ZSBpdCBhcm91bmQsIG5vIG5lZWQgdG8gcmVz
cGluIGZvciB0aGlzLgo+CgpUaGFua3MgTWFyYy4KCgo+IFRoYW5rcywKPgo+ICAgICAgICAgTS4K
Pgo+IC0tCj4gV2l0aG91dCBkZXZpYXRpb24gZnJvbSB0aGUgbm9ybSwgcHJvZ3Jlc3MgaXMgbm90
IHBvc3NpYmxlLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
