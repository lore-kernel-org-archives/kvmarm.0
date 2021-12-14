Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BEFC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 15:37:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3A4B4B12E;
	Tue, 14 Dec 2021 10:37:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmx.net
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4n6SYUeQSPrL; Tue, 14 Dec 2021 10:37:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B71E24B225;
	Tue, 14 Dec 2021 10:37:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D2D84B105
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:59:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V4MTtFqYYotq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 05:59:25 -0500 (EST)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A21C4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:59:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=badeba3b8450; t=1639479560;
 bh=smJHWvygk0id6MvmjwCB/eL3oP+0G+fWcwQ3N+ju92c=;
 h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
 b=FaPS0gUPgkHpTpEaWyOtsLoVcGsoHMHys4e/nQvoFEPR61mZb/CWt2U+B6E85MW28
 9OdBIw1lAqA6lBDhUOqECgFcnuDr2phpvHUshAdCSXPyOc6I/wsvoKeinpSuIQ2DxA
 eqY7jidCn5OCQQdGx6SKR7KzprbFLdTUuqZLozLU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M5fMe-1mr0zK04CY-007CUj; Tue, 14
 Dec 2021 11:59:20 +0100
Message-ID: <8693375e-6f29-16f4-4fa4-2fd79a00ebd0@gmx.com>
Date: Tue, 14 Dec 2021 18:59:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org> <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
 <87fsqvjzs5.wl-maz@kernel.org> <YbhzuKQLByleh3T8@redhat.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
In-Reply-To: <YbhzuKQLByleh3T8@redhat.com>
X-Provags-ID: V03:K1:uLSswNaD0Oo3jSZHyL+WRNC6iCOp1OCoolavsGFDEtaOeqks4eX
 GLsitnQA7lrJ1R31L7bL6ihUZtZWe33i61CQle57b+gEiarSrnTMwn2k4n8ALjGuTO4hSSJ
 OTSNqsyeT4t2EVMvkVQTTkGLdKMVQVMAu/dUMyPusIT9pLOIBlf2Yi/MgSCmXitAesbgMel
 PHRhWAytSi2h/lIBc9urQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:HVf/pnrV3zA=:NQuvWxEFEZsc9YSwascewO
 GG6G3wMaIdBhug0JJpIWpfLSckslcQl4TXXxnieiFVibF8gH9D2wHZ/WJopAAstVzi5MTyPPH
 lmXQ9R3sRuslHuCkaCVd1l+uf+TmVGLJHOMnUdLftcjy6oX9lX9eN2H6qcGhyqcjDkBaz5kXq
 uAiLCrZgJrxQVy7qOB/vz0Ef4r8FoUyatUE5Fska6LmY7uSjwieoqxT0mNqIwr2ohVwoqtqxR
 S+XMVaVyrpY7Xx6EREfdga/bMgypObsmP6pjygzFVpskBelM9Rmk0ujBbqwc/P2J+He+mRB84
 UKSJnvdRIDtDSQPX7c3iMFSOILtQyN/jU7iw670WJu/u7MX5+cfpuGJyRSIwFLH+rzRjA5w8t
 Vtbb39e08uCVzVqksbFh+cKT2rhGMGgC4JcRo32Zbl6oVdz3pgyd+zXhqojOoi+6IVsncqrjr
 LM7RVzD4CPiljDqC2UJdHwmbISxgjCbiJBOlaESalve7XLUKkeVHKHZfgH1cQxgpn1w1X/CDc
 1GB5n39P6DWX7TWo4S34E8h1/06/BOJu8KqHSehKMV6dzSMr0sOffdg5teI3/p+PScc9hnwt/
 PiphmlVPOuNCCO2aO/L0BoHNEM6OA/Lin0bYiu4Tc42gQn9g0BEoyvuBwtKfWFuGwXPWCU6+h
 tMcZ0EFHsImUYaXWb4BdDU1j7SgjtmhVbDwirv+vBqziJlGRsxFUesGJXN3NocpgK0LPY0lO6
 ji5v600iEyMSjL6a6mGfUAxrfKvM3tv0FhNAWXjf4wsMRxOZz6dNWrDI4pFv4qcTbiEAlomKI
 kHY5LqBhllGZyxkXnR23uxygamsiAOlHesL1MDXbnenX1LLpT25l8NrSgF+SsYlcFX1OhixH+
 +2PuM4Xw85bWmx22KDU/OOF32kFWP70YclA2zPiyAGzk65GxuMusWRgmIhrMcvwS/5v5NVjE1
 GgTXusvYBGa7sTfq0UsZLiEAo8VMj2RvK2RxnLTOR3NyhGGVEKmZtI0zJqJkIBVeA50Px/YhH
 i5t20bMfU6pIVU18ZftszgN32YJ22luanVI4fzjh2fHzkY+vnLoX9PjmWzBM9rmSJjKSmrVAd
 dbpzOD06GhZLhA=
X-Mailman-Approved-At: Tue, 14 Dec 2021 10:37:24 -0500
Cc: =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
 qemu-discuss@nongnu.org, libvirt-users@redhat.com, qemu-arm@nongnu.org,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

CgpPbiAyMDIxLzEyLzE0IDE4OjM2LCBEYW5pZWwgUC4gQmVycmFuZ8OpIHdyb3RlOgo+IE9uIFR1
ZSwgRGVjIDE0LCAyMDIxIGF0IDA5OjM0OjE4QU0gKzAwMDAsIE1hcmMgWnluZ2llciB3cm90ZToK
Pj4gT24gVHVlLCAxNCBEZWMgMjAyMSAwMDo0MTowMSArMDAwMCwKPj4gUXUgV2VucnVvIDxxdXdl
bnJ1by5idHJmc0BnbXguY29tPiB3cm90ZToKPj4+Cj4+Pgo+Pj4KPj4+IE9uIDIwMjEvMTIvMTQg
MDA6NDksIE1hcmMgWnluZ2llciB3cm90ZToKPj4+PiBPbiBNb24sIDEzIERlYyAyMDIxIDE2OjA2
OjE0ICswMDAwLAo+Pj4+IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4g
d3JvdGU6Cj4+Pj4+Cj4+Pj4+IEtWTSBvbiBiaWcubGl0dGxlIHNldHVwcyBpcyBhIGtlcm5lbC1s
ZXZlbCBxdWVzdGlvbiByZWFsbHk7IEkndmUKPj4+Pj4gY2MnZCB0aGUga3ZtYXJtIGxpc3QuCj4+
Pj4KPj4+PiBUaGFua3MgUGV0ZXIgZm9yIHRocm93aW5nIHVzIHVuZGVyIHRoZSBiaWctbGl0dGxl
IGJ1cyEgOy0pCj4+Pj4KPj4+Pj4KPj4+Pj4gT24gTW9uLCAxMyBEZWMgMjAyMSBhdCAxNTowMiwg
UXUgV2VucnVvIDxxdXdlbnJ1by5idHJmc0BnbXguY29tPiB3cm90ZToKPj4+Pj4+Cj4+Pj4+Pgo+
Pj4+Pj4KPj4+Pj4+IE9uIDIwMjEvMTIvMTMgMjE6MTcsIE1pY2hhbCBQcsOtdm96bsOtayB3cm90
ZToKPj4+Pj4+PiBPbiAxMi8xMS8yMSAwMjo1OCwgUXUgV2VucnVvIHdyb3RlOgo+Pj4+Pj4+PiBI
aSwKPj4+Pj4+Pj4KPj4+Pj4+Pj4gUmVjZW50bHkgSSBnb3QgbXkgbGlidmlydCBzZXR1cCBvbiBi
b3RoIFJLMzM5OSAoUm9ja1BybzY0KSBhbmQgUlBJIENNNCwKPj4+Pj4+Pj4gd2l0aCB1cHN0cmVh
bSBrZXJuZWxzLgo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBGb3IgUlBJIENNNCBpdHMgbW9zdGx5IHNtb290
aCBzYWlsLCBidXQgb24gUkszMzk5IGR1ZSB0byBpdHMgbGl0dGxlLkJJRwo+Pj4+Pj4+PiBzZXR1
cCAoY29yZSAwLTMgYXJlIDR4IEE1NSBjb3JlcywgYW5kIGNvcmUgNC01IGFyZSAyeCBBNzIgY29y
ZXMpLCBpdAo+Pj4+Pj4+PiBicmluZ3MgcXVpdGUgc29tZSB0cm91YmxlcyBmb3IgVk1zLgo+Pj4+
Pj4+Pgo+Pj4+Pj4+PiBJbiBzaG9ydCwgd2l0aG91dCBwcm9wZXIgY3B1c2V0IHRvIGJpbmQgdGhl
IFZNIHRvIGVpdGhlciBhbGwgQTcyIGNvcmVzCj4+Pj4+Pj4+IG9yIGFsbCBBNTUgY29yZXMsIHRo
ZSBWTSB3aWxsIG1vc3RseSBmYWlsIHRvIGJvb3QuCj4+Pj4KPj4+PiBzL0E1NS9BNTMvLiBUaGVy
ZSB3ZXJlIHRoYW5rZnVsbHkgbm8gQTcyK0E1NSBldmVyIHByb2R1Y2VkIChqdXN0IHRoZQo+Pj4+
IHRob3VnaCBvZiBpdCBtYWtlcyBtZSBzaWNrKS4KPj4+Pgo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBDdXJy
ZW50bHkgdGhlIHdvcmtpbmcgeG1sIGlzOgo+Pj4+Pj4+Pgo+Pj4+Pj4+PiAgICAgIDx2Y3B1IHBs
YWNlbWVudD0nc3RhdGljJyBjcHVzZXQ9JzQtNSc+MjwvdmNwdT4KPj4+Pj4+Pj4gICAgICA8Y3B1
IG1vZGU9J2hvc3QtcGFzc3Rocm91Z2gnIGNoZWNrPSdub25lJy8+Cj4+Pj4+Pj4+Cj4+Pj4+Pj4+
IEJ1dCBldmVuIHdpdGggdmNwdXBpbiwgcGlubmluZyBlYWNoIHZjcHUgdG8gZWFjaCBwaHlzaWNh
bCBjb3JlLCBWTSB3aWxsCj4+Pj4+Pj4+IG1vc3RseSBmYWlsIHRvIHN0YXJ0IHVwIGR1ZSB0byB2
Y3B1IGluaXRpYWxpemF0aW9uIGZhaWxlZCB3aXRoIC1FSU5WQUwuCj4+Pj4KPj4+PiBEaXNjbGFp
bWVyOiBJIGtub3cgbm90aGluZyBhYm91dCBsaWJ2aXJ0IChhbmQgbm8sIEkgZG9uJ3Qgd2FudCB0
bwo+Pj4+IGtub3chIDstKS4KPj4+Pgo+Pj4+IEhvd2V2ZXIsIGZvciB0aGluZ3MgdG8gYmUgcmVs
aWFibGUsIHlvdSBuZWVkIHRvIHRhc2tzZXQgdGhlIHdob2xlIFFFTVUKPj4+PiBwcm9jZXNzIHRv
IHRoZSBDUFUgdHlwZSB5b3UgaW50ZW5kIHRvIHVzZS4KPj4+Cj4+PiBZZXAsIHRoYXQncyB3aGF0
IEknbSBkb2luZy4KPj4KPj4gQXJlIHlvdSBzdXJlPyBUaGUgeG1sIGRpcmVjdGl2ZSBhYm92ZSBz
ZWVtIHRvIG9ubHkgYXBwbHkgdG8gdGhlIHZjcHVzLAo+PiBhbmQgbm8gb3RoZXIgUUVNVSB0aHJl
YWQuCj4KPiBGb3IgaGlzdG9yaWNhbCByZWFzb25zIHRoaXMgWE1MIGVsZW1lbnQgaXMgYSBiaXQg
bWlzbGVhZGluZ2x5IG5hbWVkLgo+Cj4gV2l0aCB0aGUgY29uZmlnCj4KPiAgICAgPHZjcHUgcGxh
Y2VtZW50PSdzdGF0aWMnIGNwdXNldD0nNC01Jz4yPC92Y3B1Pgo+Cj4gdGhlICdjcHVzZXQnIGFw
cGxpZXMgdG8gdGhlIFFFTVUgcHJvY2VzcyBhcyBhIHdob2xlIC0gaXRzIHZDUFVzLAo+IEkvTyB0
aHJlYWRzIGFuZCBhbnkgb3RoZXIgZW11bGF0b3IgdGhyZWFkcy4KPgo+IFRoZXJlIGlzIGEgc2Vw
YXJhdGUgY29uZmlnIGZvciBzZXR0aW5nIHBlci1WQ1BVIGJpbmRpbmcgd2hpY2ggd2FzCj4gaWxs
dXN0cmF0ZWQgZWxzZXdoZXJlIGluIHRoaXMgdGhyZWFkLgoKV2hpY2ggYWxzbyBtZWFucywgSSBj
YW4gcHV0IHRoZSBpbyB0aHJlYWRzIHRvIEE1MyBjb3JlcyBmcmVlaW5nIHVwIHRoZQpBNzIgY29y
ZXMgbW9yZS4KCkFuZCBpcyB0aGVyZSBhbnkgcGxhbiB0byBkZXByZWNhdGUgdGhlIG9sZCAiY3B1
c2V0IiBrZXkgb2YgdmNwdSBlbGVtZW50LAphbmQgcmVjb21tZW5kIHRvIHVzZSAidmNwdXBpbiIg
ZWxlbWVudD8KClRoYW5rcywKUXUKCj4KPiBSZWdhcmRzLAo+IERhbmllbApfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
