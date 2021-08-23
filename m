Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF6FC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 14:14:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6193961206
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 14:14:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6193961206
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C01384B238;
	Mon, 23 Aug 2021 10:14:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gWmOpS5cs3-1; Mon, 23 Aug 2021 10:13:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBAD34B1BD;
	Mon, 23 Aug 2021 10:13:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD124B1BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 10:13:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fAvPENHJMOCt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 10:13:54 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C86D4B1AB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 10:13:54 -0400 (EDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
 17NE4Ob8052048; Mon, 23 Aug 2021 10:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JP+rIuvE43NRXIUI5Kb+ogg0I/5LxIIHeZ4VT3NOJSI=;
 b=HdCP5dSGypid2RyIbAPUCk3pVDYhTdLu+iuqc1SPqEUlq9/SvNF/R0tU6SvZ55CNVBES
 rE2CCE83XX5njzTOZ2UqRVeBiZjfwprMW6Brh46ayzEXBZJY0FkCgFoxpjX3fNFXKNaO
 L5kMaEvRafRrAgjXuQ59jfxc1PZsSxUusjIqRQxMjrJ6Aq/4z26WcoeUW+BU9qVUQvUV
 ATj63FSo1ncLrS47cjKQeUGyfXXDvbf3tCux3hmnc3b4Flq2wDIY6vKG1rVGFwMNdQKH
 OoOHLDT1nwkL8Rm2aWiD+/Ag1htYp3WmD/H3VYKw9BwAcB+J5fVPbfgIlUyBXxghgKPl JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3am1eva1g9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 23 Aug 2021 10:12:50 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17NE4VX8052901;
 Mon, 23 Aug 2021 10:12:49 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3am1eva1f1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 23 Aug 2021 10:12:49 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
 by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17NE3PHm014202;
 Mon, 23 Aug 2021 14:12:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by ppma04ams.nl.ibm.com with ESMTP id 3ajs48ucq0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 23 Aug 2021 14:12:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com
 (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 17NEChTt39780754
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 23 Aug 2021 14:12:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 2DE26A4BDF;
 Mon, 23 Aug 2021 14:12:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id EE119A4BDD;
 Mon, 23 Aug 2021 14:12:40 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.170.214])
 by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Mon, 23 Aug 2021 14:12:40 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] KVM: Refactor kvm_arch_vcpu_fault() to return a
 struct page pointer
To: David Hildenbrand <david@redhat.com>,
 Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org
References: <YRQcZqCWwVH8bCGc@google.com>
 <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
 <98adbd3c-ec6f-5689-1686-2a8a7909951a@redhat.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <c228bf78-28fb-8666-e394-5ebfa1de0862@de.ibm.com>
Date: Mon, 23 Aug 2021 16:12:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <98adbd3c-ec6f-5689-1686-2a8a7909951a@redhat.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5V65b4zTLVrYqqCGUcddJc1BLzc-OYWe
X-Proofpoint-ORIG-GUID: mhbanuFWoNfFP43Rw2Ff2PaJeTjB43vn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
 definitions=2021-08-23_03:2021-08-23,
 2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108230098
Cc: x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 kvm-ppc@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

CgpPbiAxMi4wOC4yMSAxMTowNCwgRGF2aWQgSGlsZGVuYnJhbmQgd3JvdGU6Cj4gT24gMTIuMDgu
MjEgMDY6MDIsIEhvdSBXZW5sb25nIHdyb3RlOgo+PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4KPj4KPj4gUmVmYWN0b3Iga3ZtX2FyY2hfdmNwdV9mYXVsdCgp
IHRvIHJldHVybiAnc3RydWN0IHBhZ2UgKicgaW5zdGVhZCBvZgo+PiAndm1fZmF1bHRfdCcgdG8g
c2ltcGxpZnkgYXJjaGl0ZWN0dXJlIHNwZWNpZmljIGltcGxlbWVudGF0aW9ucyB0aGF0IGRvCj4+
IG1vcmUgdGhhbiByZXR1cm4gU0lHQlVTLsKgIEN1cnJlbnRseSB0aGlzIG9ubHkgYXBwbGllcyB0
byBzMzkwLCBidXQgYQo+PiBmdXR1cmUgcGF0Y2ggd2lsbCBtb3ZlIHg4NidzIHBpb19kYXRhIGhh
bmRsaW5nIGludG8geDg2IHdoZXJlIGl0IGJlbG9uZ3MuCj4+Cj4+IE5vIGZ1bmN0aW9uYWwgY2hh
bmdlZCBpbnRlbmRlZC4KPj4KPj4gQ2M6IEhvdSBXZW5sb25nIDxob3V3ZW5sb25nOTNAbGludXgu
YWxpYmFiYS5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPgo+PiBTaWduZWQtb2ZmLWJ5OiBIb3UgV2VubG9uZyA8aG91d2VubG9uZzkz
QGxpbnV4LmFsaWJhYmEuY29tPgo+PiAtLS0KPj4gwqAgYXJjaC9hcm02NC9rdm0vYXJtLmPCoMKg
wqDCoMKgwqAgfMKgIDQgKystLQo+PiDCoCBhcmNoL21pcHMva3ZtL21pcHMuY8KgwqDCoMKgwqDC
oCB8wqAgNCArKy0tCj4+IMKgIGFyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jIHzCoCA0ICsrLS0K
Pj4gwqAgYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jwqDCoCB8IDEyICsrKystLS0tLS0tLQo+PiDC
oCBhcmNoL3g4Ni9rdm0veDg2LmPCoMKgwqDCoMKgwqDCoMKgIHzCoCA0ICsrLS0KPj4gwqAgaW5j
bHVkZS9saW51eC9rdm1faG9zdC5owqDCoCB8wqAgMiArLQo+PiDCoCB2aXJ0L2t2bS9rdm1fbWFp
bi5jwqDCoMKgwqDCoMKgwqAgfMKgIDUgKysrKy0KPj4gwqAgNyBmaWxlcyBjaGFuZ2VkLCAxNyBp
bnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL2FybS5jIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4gaW5kZXggZTlhMmI4ZjI3Nzky
Li44M2Y0ZmZlM2U0ZjIgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2FybS5jCj4+ICsr
KyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jCj4+IEBAIC0xNjEsOSArMTYxLDkgQEAgaW50IGt2bV9h
cmNoX2luaXRfdm0oc3RydWN0IGt2bSAqa3ZtLCB1bnNpZ25lZCBsb25nIHR5cGUpCj4+IMKgwqDC
oMKgwqAgcmV0dXJuIHJldDsKPj4gwqAgfQo+PiAtdm1fZmF1bHRfdCBrdm1fYXJjaF92Y3B1X2Zh
dWx0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IHZtX2ZhdWx0ICp2bWYpCj4+ICtzdHJ1
Y3QgcGFnZSAqa3ZtX2FyY2hfdmNwdV9mYXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVj
dCB2bV9mYXVsdCAqdm1mKQo+PiDCoCB7Cj4+IC3CoMKgwqAgcmV0dXJuIFZNX0ZBVUxUX1NJR0JV
UzsKPj4gK8KgwqDCoCByZXR1cm4gTlVMTDsKPj4gwqAgfQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9t
aXBzL2t2bS9taXBzLmMgYi9hcmNoL21pcHMva3ZtL21pcHMuYwo+PiBpbmRleCBhZjlkZDAyOWE0
ZTEuLmFlNzk4NzRlNmZkMiAxMDA2NDQKPj4gLS0tIGEvYXJjaC9taXBzL2t2bS9taXBzLmMKPj4g
KysrIGIvYXJjaC9taXBzL2t2bS9taXBzLmMKPj4gQEAgLTEwNTMsOSArMTA1Myw5IEBAIGludCBr
dm1fYXJjaF92Y3B1X2lvY3RsX3NldF9mcHUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qg
a3ZtX2ZwdSAqZnB1KQo+PiDCoMKgwqDCoMKgIHJldHVybiAtRU5PSU9DVExDTUQ7Cj4+IMKgIH0K
Pj4gLXZtX2ZhdWx0X3Qga3ZtX2FyY2hfdmNwdV9mYXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
IHN0cnVjdCB2bV9mYXVsdCAqdm1mKQo+PiArc3RydWN0IHBhZ2UgKmt2bV9hcmNoX3ZjcHVfZmF1
bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKPj4gwqAgewo+
PiAtwqDCoMKgIHJldHVybiBWTV9GQVVMVF9TSUdCVVM7Cj4+ICvCoMKgwqAgcmV0dXJuIE5VTEw7
Cj4+IMKgIH0KPj4gwqAgaW50IGt2bV92bV9pb2N0bF9jaGVja19leHRlbnNpb24oc3RydWN0IGt2
bSAqa3ZtLCBsb25nIGV4dCkKPj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJw
Yy5jIGIvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMKPj4gaW5kZXggYmUzM2I1MzIxYTc2Li5i
OWMyMWY5YWI3ODQgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jCj4+
ICsrKyBiL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jCj4+IEBAIC0yMDkwLDkgKzIwOTAsOSBA
QCBsb25nIGt2bV9hcmNoX3ZjcHVfaW9jdGwoc3RydWN0IGZpbGUgKmZpbHAsCj4+IMKgwqDCoMKg
wqAgcmV0dXJuIHI7Cj4+IMKgIH0KPj4gLXZtX2ZhdWx0X3Qga3ZtX2FyY2hfdmNwdV9mYXVsdChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCB2bV9mYXVsdCAqdm1mKQo+PiArc3RydWN0IHBh
Z2UgKmt2bV9hcmNoX3ZjcHVfZmF1bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qgdm1f
ZmF1bHQgKnZtZikKPj4gwqAgewo+PiAtwqDCoMKgIHJldHVybiBWTV9GQVVMVF9TSUdCVVM7Cj4+
ICvCoMKgwqAgcmV0dXJuIE5VTEw7Cj4+IMKgIH0KPj4gwqAgc3RhdGljIGludCBrdm1fdm1faW9j
dGxfZ2V0X3B2aW5mbyhzdHJ1Y3Qga3ZtX3BwY19wdmluZm8gKnB2aW5mbykKPj4gZGlmZiAtLWdp
dCBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYwo+
PiBpbmRleCAwMjU3NGQ3YjM2MTIuLmUxYjY5ODMzZTIyOCAxMDA2NDQKPj4gLS0tIGEvYXJjaC9z
MzkwL2t2bS9rdm0tczM5MC5jCj4+ICsrKyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYwo+PiBA
QCAtNDk3OSwxNyArNDk3OSwxMyBAQCBsb25nIGt2bV9hcmNoX3ZjcHVfaW9jdGwoc3RydWN0IGZp
bGUgKmZpbHAsCj4+IMKgwqDCoMKgwqAgcmV0dXJuIHI7Cj4+IMKgIH0KPj4gLXZtX2ZhdWx0X3Qg
a3ZtX2FyY2hfdmNwdV9mYXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCB2bV9mYXVs
dCAqdm1mKQo+PiArc3RydWN0IHBhZ2UgKmt2bV9hcmNoX3ZjcHVfZmF1bHQoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LCBzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKPj4gwqAgewo+PiDCoCAjaWZkZWYgQ09O
RklHX0tWTV9TMzkwX1VDT05UUk9MCj4+IC3CoMKgwqAgaWYgKCh2bWYtPnBnb2ZmID09IEtWTV9T
MzkwX1NJRV9QQUdFX09GRlNFVCkKPj4gLcKgwqDCoMKgwqDCoMKgwqAgJiYgKGt2bV9pc191Y29u
dHJvbCh2Y3B1LT5rdm0pKSkgewo+PiAtwqDCoMKgwqDCoMKgwqAgdm1mLT5wYWdlID0gdmlydF90
b19wYWdlKHZjcHUtPmFyY2guc2llX2Jsb2NrKTsKPj4gLcKgwqDCoMKgwqDCoMKgIGdldF9wYWdl
KHZtZi0+cGFnZSk7Cj4+IC3CoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsKPj4gLcKgwqDCoCB9Cj4+
ICvCoMKgwqAgaWYgKHZtZi0+cGdvZmYgPT0gS1ZNX1MzOTBfU0lFX1BBR0VfT0ZGU0VUICYmIGt2
bV9pc191Y29udHJvbCh2Y3B1LT5rdm0pKQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHZpcnRf
dG9fcGFnZSh2Y3B1LT5hcmNoLnNpZV9ibG9jayk7Cj4+IMKgICNlbmRpZgo+PiAtwqDCoMKgIHJl
dHVybiBWTV9GQVVMVF9TSUdCVVM7Cj4+ICvCoMKgwqAgcmV0dXJuIE5VTEw7Cj4+IMKgIH0KPj4g
wqAgLyogU2VjdGlvbjogbWVtb3J5IHJlbGF0ZWQgKi8KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYwo+PiBpbmRleCAzY2VkYzdjYzEzMmEuLjFl
M2JiZTVjZDMzYSAxMDA2NDQKPj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jCj4+ICsrKyBiL2Fy
Y2gveDg2L2t2bS94ODYuYwo+PiBAQCAtNTM0Nyw5ICs1MzQ3LDkgQEAgbG9uZyBrdm1fYXJjaF92
Y3B1X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxwLAo+PiDCoMKgwqDCoMKgIHJldHVybiByOwo+PiDC
oCB9Cj4+IC12bV9mYXVsdF90IGt2bV9hcmNoX3ZjcHVfZmF1bHQoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKPj4gK3N0cnVjdCBwYWdlICprdm1fYXJjaF92Y3B1
X2ZhdWx0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IHZtX2ZhdWx0ICp2bWYpCj4+IMKg
IHsKPj4gLcKgwqDCoCByZXR1cm4gVk1fRkFVTFRfU0lHQlVTOwo+PiArwqDCoMKgIHJldHVybiBO
VUxMOwo+PiDCoCB9Cj4+IMKgIHN0YXRpYyBpbnQga3ZtX3ZtX2lvY3RsX3NldF90c3NfYWRkcihz
dHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGxvbmcgYWRkcikKPj4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+PiBpbmRleCA0
OTJkMTgzZGQ3ZDAuLmE5NDlkZTUzNDcyMiAxMDA2NDQKPj4gLS0tIGEvaW5jbHVkZS9saW51eC9r
dm1faG9zdC5oCj4+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+PiBAQCAtOTk1LDcg
Kzk5NSw3IEBAIGxvbmcga3ZtX2FyY2hfZGV2X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxwLAo+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgaW9jdGwsIHVuc2lnbmVkIGxv
bmcgYXJnKTsKPj4gwqAgbG9uZyBrdm1fYXJjaF92Y3B1X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxw
LAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCBpb2N0bCwgdW5z
aWduZWQgbG9uZyBhcmcpOwo+PiAtdm1fZmF1bHRfdCBrdm1fYXJjaF92Y3B1X2ZhdWx0KHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IHZtX2ZhdWx0ICp2bWYpOwo+PiArc3RydWN0IHBhZ2Ug
Kmt2bV9hcmNoX3ZjcHVfZmF1bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qgdm1fZmF1
bHQgKnZtZik7Cj4+IMKgIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0cnVjdCBr
dm0gKmt2bSwgbG9uZyBleHQpOwo+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0va3ZtX21haW4uYyBi
L3ZpcnQva3ZtL2t2bV9tYWluLmMKPj4gaW5kZXggMzBkMzIyNTE5MjUzLi5mN2QyMTQxODk3MWIg
MTAwNjQ0Cj4+IC0tLSBhL3ZpcnQva3ZtL2t2bV9tYWluLmMKPj4gKysrIGIvdmlydC9rdm0va3Zt
X21haW4uYwo+PiBAQCAtMzQ0OCw3ICszNDQ4LDEwIEBAIHN0YXRpYyB2bV9mYXVsdF90IGt2bV92
Y3B1X2ZhdWx0KHN0cnVjdCB2bV9mYXVsdCAqdm1mKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAmdmNwdS0+ZGlydHlfcmluZywKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm1m
LT5wZ29mZiAtIEtWTV9ESVJUWV9MT0dfUEFHRV9PRkZTRVQpOwo+PiDCoMKgwqDCoMKgIGVsc2UK
Pj4gLcKgwqDCoMKgwqDCoMKgIHJldHVybiBrdm1fYXJjaF92Y3B1X2ZhdWx0KHZjcHUsIHZtZik7
Cj4+ICvCoMKgwqDCoMKgwqDCoCBwYWdlID0ga3ZtX2FyY2hfdmNwdV9mYXVsdCh2Y3B1LCB2bWYp
Owo+PiArwqDCoMKgIGlmICghcGFnZSkKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBWTV9GQVVM
VF9TSUdCVVM7Cj4+ICsKPj4gwqDCoMKgwqDCoCBnZXRfcGFnZShwYWdlKTsKPj4gwqDCoMKgwqDC
oCB2bWYtPnBhZ2UgPSBwYWdlOwo+PiDCoMKgwqDCoMKgIHJldHVybiAwOwo+Pgo+IAo+IFJldmll
d2VkLWJ5OiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4KPiAKPiBCdXQgYXQg
dGhlIHNhbWUgdGltZSBJIHdvbmRlciBpZiB3ZSBzaG91bGQganVzdCBnZXQgcmlkIG9mIENPTkZJ
R19LVk1fUzM5MF9VQ09OVFJPTCBhbmQgY29uc2VxdWVudGx5IGt2bV9hcmNoX3ZjcHVfZmF1bHQo
KS4KPiAKPiAKPiBJbiBwcmFjdGljZSBDT05GSUdfS1ZNX1MzOTBfVUNPTlRST0wsIGlzIG5ldmVy
IGVuYWJsZWQgaW4gYW55IHJlYXNvbmFibGUga2VybmVsIGJ1aWxkIGFuZCBjb25zZXF1ZW50bHkg
aXQncyBuZXZlciB0ZXN0ZWQ7IGZ1cnRoZXIsIGV4cG9zaW5nIHRoZSBzaWVfYmxvY2sgdG8gdXNl
ciBzcGFjZSBhbGxvd3MgdXNlciBzcGFjZSB0byBnZW5lcmF0ZSByYW5kb20gU0lFIHZhbGlkaXR5
IGludGVyY2VwdHMuCj4gCj4gQ09ORklHX0tWTV9TMzkwX1VDT05UUk9MIGZlZWxzIGxpa2Ugc29t
ZXRoaW5nIHRoYXQgc2hvdWxkIGp1c3QgYmUgbWFpbnRhaW5lZCBvdXQgb2YgdHJlZSBieSBzb21l
b25lIHdobyByZWFsbHkgbmVlZHMgdG8gaGFjayBkZWVwIGludG8gaHcgdmlydHVhbGl6YXRpb24g
Zm9yIHRlc3RpbmcgcHVycG9zZXMgZXRjLgoKSSByZWNlbnRseSB0YWxrZWQgdG8gdGhlIHVjb250
cm9sIHVzZXJzIGFuZCB0aGV5IHdpbGwgbG9vayBpbnRvIHNlbGZ0ZXN0cy4KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
