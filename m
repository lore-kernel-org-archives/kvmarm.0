Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B86C11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:38:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C8FA61410
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:38:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C8FA61410
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58C8E4A1A7;
	Fri,  2 Jul 2021 12:38:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jMhqOQCXHtNT; Fri,  2 Jul 2021 12:38:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8404449F8F;
	Fri,  2 Jul 2021 12:38:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A52949E72
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:38:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HyC-ZHR7qgSd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 12:38:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCF4A49D50
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:38:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45060147A;
 Fri,  2 Jul 2021 09:38:43 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.15.239])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94E3C3F5A1;
 Fri,  2 Jul 2021 09:38:38 -0700 (PDT)
Date: Fri, 2 Jul 2021 17:38:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <20210702163836.GB94260@C02TD0UTHF1T.local>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
 <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
 <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
Cc: wanpengli@tencent.com, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, eranian@google.com,
 weijiang.yang@intel.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 Like Xu <like.xu@linux.intel.com>, Marc Zyngier <maz@kernel.org>,
 joro@8bytes.org, x86@kernel.org, linux-csky@vger.kernel.org,
 wei.w.wang@intel.com, xen-devel@lists.xenproject.org, liuxiangdong5@huawei.com,
 bp@alien8.de, Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, vkuznets@redhat.com,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 Zhu Lingshan <lingshan.zhu@intel.com>
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

T24gRnJpLCBKdWwgMDIsIDIwMjEgYXQgMDk6MDA6MjJBTSAtMDcwMCwgSm9lIFBlcmNoZXMgd3Jv
dGU6Cj4gT24gRnJpLCAyMDIxLTA3LTAyIGF0IDEzOjIyICswMjAwLCBQZXRlciBaaWpsc3RyYSB3
cm90ZToKPiA+IE9uIFR1ZSwgSnVuIDIyLCAyMDIxIGF0IDA1OjQyOjQ5UE0gKzA4MDAsIFpodSBM
aW5nc2hhbiB3cm90ZToKPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2V2ZW50cy9jb3JlLmMg
Yi9hcmNoL3g4Ni9ldmVudHMvY29yZS5jCj4gW10KPiA+ID4gQEAgLTkwLDYgKzkwLDI3IEBAIERF
RklORV9TVEFUSUNfQ0FMTF9OVUxMKHg4Nl9wbXVfcGVic19hbGlhc2VzLCAqeDg2X3BtdS5wZWJz
X2FsaWFzZXMpOwo+ID4gPiDCoMKgKi8KPiA+ID4gwqBERUZJTkVfU1RBVElDX0NBTExfUkVUMCh4
ODZfcG11X2d1ZXN0X2dldF9tc3JzLCAqeDg2X3BtdS5ndWVzdF9nZXRfbXNycyk7Cj4gPiA+IMKg
Cj4gPiA+IAo+ID4gPiArREVGSU5FX1NUQVRJQ19DQUxMX1JFVDAoeDg2X2d1ZXN0X3N0YXRlLCAq
KHBlcmZfZ3Vlc3RfY2JzLT5zdGF0ZSkpOwo+ID4gPiArREVGSU5FX1NUQVRJQ19DQUxMX1JFVDAo
eDg2X2d1ZXN0X2dldF9pcCwgKihwZXJmX2d1ZXN0X2Nicy0+Z2V0X2lwKSk7Cj4gPiA+ICtERUZJ
TkVfU1RBVElDX0NBTExfUkVUMCh4ODZfZ3Vlc3RfaGFuZGxlX2ludGVsX3B0X2ludHIsICoocGVy
Zl9ndWVzdF9jYnMtPmhhbmRsZV9pbnRlbF9wdF9pbnRyKSk7Cj4gPiA+ICsKPiA+ID4gK3ZvaWQg
YXJjaF9wZXJmX3VwZGF0ZV9ndWVzdF9jYnModm9pZCkKPiA+ID4gK3sKPiA+ID4gKwlzdGF0aWNf
Y2FsbF91cGRhdGUoeDg2X2d1ZXN0X3N0YXRlLCAodm9pZCAqKSZfX3N0YXRpY19jYWxsX3JldHVy
bjApOwo+ID4gPiArCXN0YXRpY19jYWxsX3VwZGF0ZSh4ODZfZ3Vlc3RfZ2V0X2lwLCAodm9pZCAq
KSZfX3N0YXRpY19jYWxsX3JldHVybjApOwo+ID4gPiArCXN0YXRpY19jYWxsX3VwZGF0ZSh4ODZf
Z3Vlc3RfaGFuZGxlX2ludGVsX3B0X2ludHIsICh2b2lkICopJl9fc3RhdGljX2NhbGxfcmV0dXJu
MCk7Cj4gPiA+ICsKPiA+ID4gKwlpZiAocGVyZl9ndWVzdF9jYnMgJiYgcGVyZl9ndWVzdF9jYnMt
PnN0YXRlKQo+ID4gPiArCQlzdGF0aWNfY2FsbF91cGRhdGUoeDg2X2d1ZXN0X3N0YXRlLCBwZXJm
X2d1ZXN0X2Nicy0+c3RhdGUpOwo+ID4gPiArCj4gPiA+ICsJaWYgKHBlcmZfZ3Vlc3RfY2JzICYm
IHBlcmZfZ3Vlc3RfY2JzLT5nZXRfaXApCj4gPiA+ICsJCXN0YXRpY19jYWxsX3VwZGF0ZSh4ODZf
Z3Vlc3RfZ2V0X2lwLCBwZXJmX2d1ZXN0X2Nicy0+Z2V0X2lwKTsKPiA+ID4gKwo+ID4gPiArCWlm
IChwZXJmX2d1ZXN0X2NicyAmJiBwZXJmX2d1ZXN0X2Nicy0+aGFuZGxlX2ludGVsX3B0X2ludHIp
Cj4gPiA+ICsJCXN0YXRpY19jYWxsX3VwZGF0ZSh4ODZfZ3Vlc3RfaGFuZGxlX2ludGVsX3B0X2lu
dHIsCj4gPiA+ICsJCQkJICAgcGVyZl9ndWVzdF9jYnMtPmhhbmRsZV9pbnRlbF9wdF9pbnRyKTsK
PiA+ID4gK30KPiA+IAo+ID4gQ29kaW5nIHN0eWxlIHdhbnRzIHsgfSBvbiB0aGF0IGxhc3QgaWYo
KS4KPiAKPiBUaGF0J3MganVzdCB5b3VyIHBlcnNvbmFsIHByZWZlcmVuY2UuCj4gCj4gVGhlIGNv
ZGluZy1zdHlsZSBkb2N1bWVudCBkb2Vzbid0IHJlcXVpcmUgdGhhdC4KPiAKPiBJdCBqdXN0IHNh
eXMgc2luZ2xlIHN0YXRlbWVudC4gIEl0J3Mgbm90IHRoZSBudW1iZXIgb2YKPiB2ZXJ0aWNhbCBs
aW5lcyBvciBjaGFyYWN0ZXJzIHJlcXVpcmVkIGZvciB0aGUgc3RhdGVtZW50Lgo+IAo+IC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAKPiBEbyBub3QgdW5uZWNlc3NhcmlseSB1
c2UgYnJhY2VzIHdoZXJlIGEgc2luZ2xlIHN0YXRlbWVudCB3aWxsIGRvLgo+IAo+IC4uIGNvZGUt
YmxvY2s6OiBjCj4gCj4gCWlmIChjb25kaXRpb24pCj4gCQlhY3Rpb24oKTsKPiAKPiBhbmQKPiAK
PiAuLiBjb2RlLWJsb2NrOjogbm9uZQo+IAo+IAlpZiAoY29uZGl0aW9uKQo+IAkJZG9fdGhpcygp
Owo+IAllbHNlCj4gCQlkb190aGF0KCk7Cj4gCj4gVGhpcyBkb2VzIG5vdCBhcHBseSBpZiBvbmx5
IG9uZSBicmFuY2ggb2YgYSBjb25kaXRpb25hbCBzdGF0ZW1lbnQgaXMgYSBzaW5nbGUKPiBzdGF0
ZW1lbnQ7IGluIHRoZSBsYXR0ZXIgY2FzZSB1c2UgYnJhY2VzIGluIGJvdGggYnJhbmNoZXM6CgpJ
bW1lZGlhdGVseSBhZnRlciB0aGlzLCB3ZSBzYXk6Cgp8IEFsc28sIHVzZSBicmFjZXMgd2hlbiBh
IGxvb3AgY29udGFpbnMgbW9yZSB0aGFuIGEgc2luZ2xlIHNpbXBsZSBzdGF0ZW1lbnQ6CnwKfCAu
LiBjb2RlLWJsb2NrOjogYwp8IAp8ICAgICAgICAgd2hpbGUgKGNvbmRpdGlvbikgewp8ICAgICAg
ICAgICAgICAgICBpZiAodGVzdCkKfCAgICAgICAgICAgICAgICAgICAgICAgICBkb19zb21ldGhp
bmcoKTsKfCAgICAgICAgIH0KfCAKCi4uLiBhbmQgd2hpbGUgdGhhdCBzYXlzICJhIGxvb3AiLCB0
aGUgcHJpbmNpcGxlIGlzIG9idmlvdXNseSBzdXBwb3NlZCB0bwphcHBseSB0byBjb25kaXRpb25h
bHMgdG9vOyBzdHJ1Y3R1cmFsbHkgdGhleSdyZSBubyBkaWZmZXJlbnQuIFdlIHNob3VsZApqdXN0
IGZpeCB0aGUgZG9jdW1lbnRhdGlvbiB0byBzYXkgImEgbG9vcCBvciBjb25kaXRpb25hbCIsIG9y
IHNvbWV0aGluZwp0byB0aGF0IGVmZmVjdC4KCk1hcmsuCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
