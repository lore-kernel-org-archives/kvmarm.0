Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE516C2BA19
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 13:11:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6550620737
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 13:11:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6550620737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6FD44B14C;
	Wed, 15 Apr 2020 09:11:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dzTkzdgLkmTo; Wed, 15 Apr 2020 09:11:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FB04B229;
	Wed, 15 Apr 2020 09:11:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDF354B158
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 07:37:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vJO3d0NWP3JN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 07:37:33 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 973964B0FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 07:37:33 -0400 (EDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
 03FBa7gl002842
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 07:37:32 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
 by mx0a-001b2d01.pphosted.com with ESMTP id 30dnmghjab-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 07:37:32 -0400
Received: from localhost
 by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <imbrenda@linux.ibm.com>;
 Wed, 15 Apr 2020 12:37:02 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
 by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway:
 Authorized Use Only! Violators will be prosecuted; 
 (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
 Wed, 15 Apr 2020 12:36:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
 [9.149.105.61])
 by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 03FBbMGa54264042
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 15 Apr 2020 11:37:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 25EB911C054;
 Wed, 15 Apr 2020 11:37:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 29D7C11C04C;
 Wed, 15 Apr 2020 11:37:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.13])
 by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Wed, 15 Apr 2020 11:37:21 +0000 (GMT)
Date: Wed, 15 Apr 2020 13:37:18 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: Re: [PATCH v2] kvm_host: unify VM_STAT and VCPU_STAT definitions in
 a single place
In-Reply-To: <992ede27-3eae-f2da-ad38-1d3498853ad2@redhat.com>
References: <20200414155625.20559-1-eesposit@redhat.com>
 <b479e7ff-4534-5ced-e19b-2a2914905a8b@amsat.org>
 <992ede27-3eae-f2da-ad38-1d3498853ad2@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-TM-AS-GCONF: 00
x-cbid: 20041511-0008-0000-0000-00000371193C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041511-0009-0000-0000-00004A92CCDF
Message-Id: <20200415133718.2db57666@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138, 18.0.676
 definitions=2020-04-15_02:2020-04-14,
 2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1011 mlxscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150084
X-Mailman-Approved-At: Wed, 15 Apr 2020 09:11:03 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

T24gV2VkLCAxNSBBcHIgMjAyMCAxMDozMDowNiArMDIwMApFbWFudWVsZSBHaXVzZXBwZSBFc3Bv
c2l0byA8ZWVzcG9zaXRAcmVkaGF0LmNvbT4gd3JvdGU6Cgo+IE9uIDQvMTUvMjAgODozNiBBTSwg
UGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6Cj4gPiBPbiA0LzE0LzIwIDU6NTYgUE0sIEVt
YW51ZWxlIEdpdXNlcHBlIEVzcG9zaXRvIHdyb3RlOiAgCj4gPj4gVGhlIG1hY3JvcyBWTV9TVEFU
IGFuZCBWQ1BVX1NUQVQgYXJlIHJlZHVuZGFudGx5IGltcGxlbWVudGVkIGluCj4gPj4gbXVsdGlw
bGUgZmlsZXMsIGVhY2ggdXNlZCBieSBhIGRpZmZlcmVudCBhcmNoaXRlY3VyZSB0byBpbml0aWFs
aXplCj4gPj4gdGhlIGRlYnVnZnMgZW50cmllcyBmb3Igc3RhdGlzdGljcy4gU2luY2UgdGhleSBh
bGwgaGF2ZSB0aGUgc2FtZQo+ID4+IHB1cnBvc2UsIHRoZXkgY2FuIGJlIHVuaWZpZWQgaW4gYSBz
aW5nbGUgY29tbW9uIGRlZmluaXRpb24gaW4KPiA+PiBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgK
PiA+Pgo+ID4+IFNpZ25lZC1vZmYtYnk6IEVtYW51ZWxlIEdpdXNlcHBlIEVzcG9zaXRvIDxlZXNw
b3NpdEByZWRoYXQuY29tPgo+ID4+IC0tLQo+ID4+ICAgYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYyAg
ICB8ICAyMyArKy0tLQo+ID4+ICAgYXJjaC9taXBzL2t2bS9taXBzLmMgICAgICB8ICA2MSArKysr
KystLS0tLS0KPiA+PiAgIGFyY2gvcG93ZXJwYy9rdm0vYm9vazNzLmMgfCAgNjEgKysrKysrLS0t
LS0tCj4gPj4gICBhcmNoL3Bvd2VycGMva3ZtL2Jvb2tlLmMgIHwgIDQxICsrKystLS0tCj4gPj4g
ICBhcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMgIHwgMjAzCj4gPj4gKysrKysrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tLS0tLS0tLS0gYXJjaC94ODYva3ZtL3g4Ni5jICAgICAgICB8Cj4gPj4gIDgw
ICsrKysrKystLS0tLS0tLSBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggIHwgICA1ICsKPiA+PiAg
IDcgZmlsZXMgY2hhbmdlZCwgMjMxIGluc2VydGlvbnMoKyksIDI0MyBkZWxldGlvbnMoLSkKPiA+
Pgo+ID4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9ndWVzdC5jIGIvYXJjaC9hcm02NC9r
dm0vZ3Vlc3QuYwo+ID4+IGluZGV4IDIzZWJlNTE0MTBmMC4uODQxN2IyMDBiZWM5IDEwMDY0NAo+
ID4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMKPiA+PiArKysgYi9hcmNoL2FybTY0L2t2
bS9ndWVzdC5jCj4gPj4gQEAgLTI5LDIwICsyOSwxNyBAQAo+ID4+ICAgCj4gPj4gICAjaW5jbHVk
ZSAidHJhY2UuaCIKPiA+PiAgIAo+ID4+IC0jZGVmaW5lIFZNX1NUQVQoeCkgeyAjeCwgb2Zmc2V0
b2Yoc3RydWN0IGt2bSwgc3RhdC54KSwKPiA+PiBLVk1fU1RBVF9WTSB9IC0jZGVmaW5lIFZDUFVf
U1RBVCh4KSB7ICN4LCBvZmZzZXRvZihzdHJ1Y3QKPiA+PiBrdm1fdmNwdSwgc3RhdC54KSwgS1ZN
X1NUQVRfVkNQVSB9IC0KPiA+PiAgIHN0cnVjdCBrdm1fc3RhdHNfZGVidWdmc19pdGVtIGRlYnVn
ZnNfZW50cmllc1tdID0gewo+ID4+IC0JVkNQVV9TVEFUKGhhbHRfc3VjY2Vzc2Z1bF9wb2xsKSwK
PiA+PiAtCVZDUFVfU1RBVChoYWx0X2F0dGVtcHRlZF9wb2xsKSwKPiA+PiAtCVZDUFVfU1RBVCho
YWx0X3BvbGxfaW52YWxpZCksCj4gPj4gLQlWQ1BVX1NUQVQoaGFsdF93YWtldXApLAo+ID4+IC0J
VkNQVV9TVEFUKGh2Y19leGl0X3N0YXQpLAo+ID4+IC0JVkNQVV9TVEFUKHdmZV9leGl0X3N0YXQp
LAo+ID4+IC0JVkNQVV9TVEFUKHdmaV9leGl0X3N0YXQpLAo+ID4+IC0JVkNQVV9TVEFUKG1taW9f
ZXhpdF91c2VyKSwKPiA+PiAtCVZDUFVfU1RBVChtbWlvX2V4aXRfa2VybmVsKSwKPiA+PiAtCVZD
UFVfU1RBVChleGl0cyksCj4gPj4gKwlWQ1BVX1NUQVQoImhhbHRfc3VjY2Vzc2Z1bF9wb2xsIiwg
aGFsdF9zdWNjZXNzZnVsX3BvbGwpLAo+ID4+ICsJVkNQVV9TVEFUKCJoYWx0X2F0dGVtcHRlZF9w
b2xsIiwgaGFsdF9hdHRlbXB0ZWRfcG9sbCksCj4gPj4gKwlWQ1BVX1NUQVQoImhhbHRfcG9sbF9p
bnZhbGlkIiwgaGFsdF9wb2xsX2ludmFsaWQpLAo+ID4+ICsJVkNQVV9TVEFUKCJoYWx0X3dha2V1
cCIsIGhhbHRfd2FrZXVwKSwKPiA+PiArCVZDUFVfU1RBVCgiaHZjX2V4aXRfc3RhdCIsIGh2Y19l
eGl0X3N0YXQpLAo+ID4+ICsJVkNQVV9TVEFUKCJ3ZmVfZXhpdF9zdGF0Iiwgd2ZlX2V4aXRfc3Rh
dCksCj4gPj4gKwlWQ1BVX1NUQVQoIndmaV9leGl0X3N0YXQiLCB3ZmlfZXhpdF9zdGF0KSwKPiA+
PiArCVZDUFVfU1RBVCgibW1pb19leGl0X3VzZXIiLCBtbWlvX2V4aXRfdXNlciksCj4gPj4gKwlW
Q1BVX1NUQVQoIm1taW9fZXhpdF9rZXJuZWwiLCBtbWlvX2V4aXRfa2VybmVsKSwKPiA+PiArCVZD
UFVfU1RBVCgiZXhpdHMiLCBleGl0cyksCj4gPj4gICAJeyBOVUxMIH0KPiA+PiAgIH07ICAKPiA+
IAo+ID4gUGF0Y2ggZWFzaWx5IHJldmlld2VkIHdpdGggLS13b3JkLWRpZmYuCj4gPiAKPiA+IFsu
Li5dICAKPiA+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oIGIvaW5jbHVk
ZS9saW51eC9rdm1faG9zdC5oCj4gPj4gaW5kZXggNmQ1OGJlYjY1NDU0Li4yZTZlYWQ4NzI5NTcg
MTAwNjQ0Cj4gPj4gLS0tIGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCj4gPj4gKysrIGIvaW5j
bHVkZS9saW51eC9rdm1faG9zdC5oCj4gPj4gQEAgLTExMzAsNiArMTEzMCwxMSBAQCBzdHJ1Y3Qg
a3ZtX3N0YXRzX2RlYnVnZnNfaXRlbSB7Cj4gPj4gICAjZGVmaW5lIEtWTV9EQkdGU19HRVRfTU9E
RShkYmdmc19pdGVtKQo+ID4+ICAgICAgICAgICAgICAgXCAoKGRiZ2ZzX2l0ZW0pLT5tb2RlID8g
KGRiZ2ZzX2l0ZW0pLT5tb2RlIDogMDY0NCkKPiA+PiAgIAo+ID4+ICsjZGVmaW5lIFZNX1NUQVQo
biwgeCwgLi4uKQo+ID4+IAkJCQkJCQkJCSAgIFwKPiA+PiArCXsgbiwgb2Zmc2V0b2Yoc3RydWN0
IGt2bSwgc3RhdC54KSwgS1ZNX1NUQVRfVk0sICMjCj4gPj4gX19WQV9BUkdTX18gfSArI2RlZmlu
ZSBWQ1BVX1NUQVQobiwgeCwgLi4uKQo+ID4+IAkJCQkJCQkJCSAgIFwKPiA+PiAgCj4gPiAKPiA+
IE5vdCBzdXJlIHdoaWxlIHlvdSB1c2Ugc28gbWFueSB3aGl0ZXNwYWNlcyBoZXJlLi4uIChtYXli
ZSBQYW9sbyBjYW4KPiA+IHN0cmlwIHNvbWUgd2hlbiBhcHBseWluZz8pLiAgCj4gCj4gSSBob25l
c3RseSBhbSBub3Qgc3VyZSB3aHkgaXQgYWRkZWQgZmV3IG1vcmUgc3BhY2VzIHRoYW4gSSB3YW50
ZWQsCj4gYnV0IHRoZSBpZGVhIHdhcyB0byBmb2xsb3cgdGhlIEtWTV9EQkdGU19HRVRfTU9ERSBt
YWNybyBhYm92ZSBhbmQgcHV0Cj4gdGhlIGJhY2tzbGFzaCBhdCB0aGUgZW5kIG9mIHRoZSBsaW5l
ICg4MHRoIGNoYXIpLgoKb25jZSB0aGUgd2hpdGVzcGFjZSBpc3N1ZXMgYXJlIGZpeGVkLCB5b3Ug
Y2FuIGFsc28gYWRkCgpSZXZpZXdlZC1ieTogQ2xhdWRpbyBJbWJyZW5kYSA8aW1icmVuZGFAbGlu
dXguaWJtLmNvbT4KIAo+ID4gCj4gPiBPdGhlcndpc2UgaXQgbG9va3MgbmljZXIgdGhhdCB2MSwg
dGhhbmtzLgo+ID4gCj4gPiBSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPGY0
YnVnQGFtc2F0Lm9yZz4KPiA+ICAgCj4gPj4gKwl7IG4sIG9mZnNldG9mKHN0cnVjdCBrdm1fdmNw
dSwgc3RhdC54KSwgS1ZNX1NUQVRfVkNQVSwgIyMKPiA+PiBfX1ZBX0FSR1NfXyB9ICsKPiA+PiAg
IGV4dGVybiBzdHJ1Y3Qga3ZtX3N0YXRzX2RlYnVnZnNfaXRlbSBkZWJ1Z2ZzX2VudHJpZXNbXTsK
PiA+PiAgIGV4dGVybiBzdHJ1Y3QgZGVudHJ5ICprdm1fZGVidWdmc19kaXI7Cj4gPj4gICAKPiA+
PiAgCj4gPiAgIAo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
