Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98946C2D0A3
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 16:42:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0231E206CA
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 16:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0231E206CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 484884B7D0;
	Wed,  4 Nov 2020 11:42:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iQ3h8Ewv5O-v; Wed,  4 Nov 2020 11:41:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F15E44B7B6;
	Wed,  4 Nov 2020 11:41:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8AC64B77E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 11:41:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7fh-I4shs9hf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 11:41:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 916194B77C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 11:41:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED7E114BF;
 Wed,  4 Nov 2020 08:41:54 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 478CF3F718;
 Wed,  4 Nov 2020 08:41:54 -0800 (PST)
Date: Wed, 4 Nov 2020 16:41:50 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fix get-reg-list regression
Message-ID: <20201104164150.GD6882@arm.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201103113726.GJ6882@arm.com>
 <20201103135244.bbgpp2b33mlqpan4@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201103135244.bbgpp2b33mlqpan4@kamzik.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: maz@kernel.org, xu910121@sina.com, kvmarm@lists.cs.columbia.edu
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

T24gVHVlLCBOb3YgMDMsIDIwMjAgYXQgMDI6NTI6NDRQTSArMDEwMCwgQW5kcmV3IEpvbmVzIHdy
b3RlOgo+IE9uIFR1ZSwgTm92IDAzLCAyMDIwIGF0IDExOjM3OjI3QU0gKzAwMDAsIERhdmUgTWFy
dGluIHdyb3RlOgo+ID4gT24gTW9uLCBOb3YgMDIsIDIwMjAgYXQgMDc6NTA6MzRQTSArMDEwMCwg
QW5kcmV3IEpvbmVzIHdyb3RlOgo+ID4gPiDlvKDkuJzml60gPHh1OTEwMTIxQHNpbmEuY29tPiBy
ZXBvcnRlZCBhIHJlZ3Jlc3Npb24gc2VlbiB3aXRoIENlbnRPUwo+ID4gPiB3aGVuIG1pZ3JhdGlu
ZyBmcm9tIGFuIG9sZCBrZXJuZWwgdG8gYSBuZXcgb25lLiBUaGUgcHJvYmxlbSB3YXMKPiA+ID4g
dGhhdCBRRU1VIHJlamVjdGVkIHRoZSBtaWdyYXRpb24gc2luY2UgS1ZNX0dFVF9SRUdfTElTVCBy
ZXBvcnRlZAo+ID4gPiBhIHJlZ2lzdGVyIHdhcyBtaXNzaW5nIG9uIHRoZSBkZXN0aW5hdGlvbi4g
RXh0cmEgcmVnaXN0ZXJzIGFyZSBPSwo+ID4gPiBvbiB0aGUgZGVzdGluYXRpb24sIGJ1dCBub3Qg
bWlzc2luZyBvbmVzLiBUaGUgcmVncmVzc2lvbiByZXByb2R1Y2VzCj4gPiA+IHdpdGggdXBzdHJl
YW0ga2VybmVscyB3aGVuIG1pZ3JhdGluZyBmcm9tIGEgNC4xNSBvciBsYXRlciBrZXJuZWwsCj4g
PiA+IHVwIHRvIG9uZSB3aXRoIGNvbW1pdCA3MzQzMzc2MmZjYWUgKCJLVk06IGFybTY0L3N2ZTog
U3lzdGVtIHJlZ2lzdGVyCj4gPiA+IGNvbnRleHQgc3dpdGNoIGFuZCBhY2Nlc3Mgc3VwcG9ydCIp
LCB0byBhIGtlcm5lbCB0aGF0IGluY2x1ZGVzIHRoYXQKPiA+ID4gY29tbWl0LCBlLmcuIHRoZSBs
YXRlc3QgbWFpbmxpbmUgKDUuMTAtcmMyKS4KPiA+ID4gCj4gPiA+IFRoZSBmaXJzdCBwYXRjaCBv
ZiB0aGlzIHNlcmllcyBpcyB0aGUgZml4LiBUaGUgbmV4dCB0d28gcGF0Y2hlcywKPiA+ID4gd2hp
Y2ggZG9uJ3QgaGF2ZSBhbnkgaW50ZW5kZWQgZnVuY3Rpb25hbCBjaGFuZ2VzLCBhbGxvdyBJRF9T
QU5JVElTRUQKPiA+ID4gdG8gYmUgdXNlZCBmb3IgcmVnaXN0ZXJzIHRoYXQgZmxpcCBiZXR3ZWVu
IGV4cG9zaW5nIGZlYXR1cmVzIGFuZAo+ID4gPiBiZWluZyBSQVosIHdoaWNoIGFsbG93cyBzb21l
IGNvZGUgdG8gYmUgcmVtb3ZlZC4KPiA+IAo+ID4gSXMgaXQgd29ydGggdXBkYXRpbmcgRG9jdW1l
bnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0IHRvIGNsYXJpZnkgdGhlCj4gPiBleHBlY3RlZCB1c2Ug
ZHVyaW5nIFZNIG1pZ3JhdGlvbnMsIGFuZCB0aGUgZ3VhcmFudGVlcyB0aGF0IGFyZSBleHBlY3Rl
ZAo+ID4gdG8gaG9sZCBiZXR3ZWVuIG1pZ3JhdGFibGUga2VybmVsIHZlcnNpb25zPyAgQ3VycmVu
dGx5IHRoZSBzcGVjaWZpY2F0aW9uCj4gPiBpcyBhIG1peHR1cmUgb2YgInN1cmVseSBpdCdzIG9i
dmlvdXMiIGFuZCAid2hhdGV2ZXIgbWFrZXMgUUVNVSB3b3JrIi4KPiA+IAo+ID4gSSBndWVzcyB0
aGF0IGNhdWdodCBtZSBvdXQsIGJ1dCBJJ2xsIGxldCBvdGhlcnMganVkZ2Ugd2hldGhlciBvdGhl
cgo+ID4gcGVvcGxlIGFyZSBsaWtlbHkgdG8gZ2V0IHNpbWlsYXJseSBjb25mdXNlZC4KPiA+Cj4g
Cj4gSSdtIG5vdCBzdXJlIHdoYXQgc2VjdGlvbiB0aGlzIHdvdWxkIGZpdCBpbiBpbiBhcGkucnN0
LiBJdCBmZWVscyBsaWtlCj4gdGhpcyBzaG91bGQgYmUgYSBoaWdoZXIgbGV2ZWwgZG9jdW1lbnQg
dGhhdCBjb3ZlcnMgdGhlIG1pZ3JhdGlvbgo+IGd1YXJhbnRlZXMgb2YgdGhlIEFQSSBpbiBnZW5l
cmFsLiBPZiBjb3Vyc2UsIHdpdGggaG9zdCBjcHUgcGFzc3Rocm91Z2gsCj4gbm90aGluZyBpcyBy
ZWFsbHkgZ3VhcmFudGVlZC4gVGhlIHVwZ3JhZGUgcGF0aCBpcyByZWFzb25hYmxlIGFuZCBwcm9i
YWJseQo+IGRvYWJsZSB0aG91Z2guCgpJIGFncmVlIHRoYXQgUUVNVSBpcyB0aGUgZG9jdW1lbnRh
dGlvbiBpbiBwcmFjdGljZSA6UAoKVGhpcyBtYXkgYmUgYSBzaXR1YXRpb24gd2hlcmUgc3RyYXRl
Z2ljIHZhZ3VlbmVzcyBpcyB0aGUgYmVzdCBwb2xpY3ksCnNpbmNlIGluIHByYWN0aWNlIHBlb3Bs
ZSBhdHRlbXB0aW5nIG1pZ3JhdGlvbiB3aWxsIGFsd2F5cyByZWx5IG9uIG1vcmUKdGhhbiB3ZSBj
YW4gc3RyaWNseSBndWFyYW50ZWUgaW4gdGhlIGdlbmVyaWMgQVBJLiAgVGhlIGdlbmVyaWMgcnVs
ZSBpcwpwcm9iYWJseSAia25vY2sgeW91cnNlbGYgb3V0LCBZTU1WIi4KCklmIHRoZXJlJ3Mgbm8g
Y2xlYXIgcGxhY2UgdG8gd3JpdGUgc29tZXRoaW5nIHVwLCB0aGVuIEkgZ3Vlc3Mgd2UgYXJlIGF0
CmxlYXN0IG5vdCBtYWtpbmcgdGhpbmdzIHdvcnNlLgoKQ2hlZXJzCi0tLURhdmUKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
