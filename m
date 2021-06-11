Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1DCC48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:01:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D77D961410
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:01:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D77D961410
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 548194B0A1;
	Fri, 11 Jun 2021 08:01:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pDLfvKhTR9HH; Fri, 11 Jun 2021 08:01:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FDD04A4C0;
	Fri, 11 Jun 2021 08:01:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4293F402DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:01:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02-V2LAUHK6A for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 08:01:27 -0400 (EDT)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EBFA400D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:01:27 -0400 (EDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
 15BBXDPL101354; Fri, 11 Jun 2021 08:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mbHNpsEeNzEvHddb7n05jQiVtEGHVhDGgdGI3qgT5cU=;
 b=iRzgFIYvoDbpwIwZ8cf1+4qafFIBZ9IK4gVOJb6pb5MQzNjfOOE5Gx2p4dnRA1vKGWuk
 shAH/zG7A4YfT5imRMBvl53mhjzVQcjBSWzJtiuGWzQMco0Ye5Kid1aA2hpvVlPpKw3Y
 WahmxjtU7CRu+Sk0I/Z4QrCTH7onWjUNGoTzt6JGVfpR4jJ+oVUTOiwjwwxAcSFnlnpA
 7bsgG1gqqP27txRSYkNO5BthxoWenMfHL4Hpv8wIrYQzxyI2K2QWJF8ohTpIWmM8qVNj
 PDdPjmfSfukd0Q2GBk3IXye1DgD8Rm9INMC3SGzjPbCYxFlsnomUwwUUPfqxldRmXFOv Og== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 39457f40xc-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 11 Jun 2021 08:00:55 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15BBYTaO105704;
 Fri, 11 Jun 2021 08:00:55 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 39457f40r7-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 11 Jun 2021 08:00:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
 by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15BBxCWJ008598;
 Fri, 11 Jun 2021 12:00:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
 (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
 by ppma04ams.nl.ibm.com with ESMTP id 3900w8bdjh-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 11 Jun 2021 12:00:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
 [9.149.105.62])
 by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP
 id 15BBxoUV33489284
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 11 Jun 2021 11:59:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 9C87AAE065;
 Fri, 11 Jun 2021 12:00:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 4546CAE057;
 Fri, 11 Jun 2021 12:00:44 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.35.90])
 by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Fri, 11 Jun 2021 12:00:44 +0000 (GMT)
Subject: Re: [PATCH v7 1/4] KVM: stats: Separate generic stats from
 architecture specific ones
To: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
 KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, Janosch Frank <frankja@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
 Oliver Upton <oupton@google.com>, David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-2-jingzhangos@google.com>
 <03f3fa03-6f61-7864-4867-3dc332a9d6f3@de.ibm.com>
 <bdd315f7-0615-af69-90c3-1e5646f3e259@redhat.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <c0173386-0c37-73c0-736a-e904636b6c94@de.ibm.com>
Date: Fri, 11 Jun 2021 14:00:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <bdd315f7-0615-af69-90c3-1e5646f3e259@redhat.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8MP2ezwEt9170vbChq_FRz0xBregGrk3
X-Proofpoint-ORIG-GUID: GqhBvqOjrdf5YHNLJ4FCXl4R-mUl-zgg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.761
 definitions=2021-06-11_05:2021-06-11,
 2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110073
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

CgpPbiAxMS4wNi4yMSAxMjo1MSwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiAxMS8wNi8yMSAw
ODo1NywgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyIHdyb3RlOgo+Pj4gQEAgLTc1NSwxMiArNzUwLDEy
IEBAIHN0cnVjdCBrdm1fdmNwdV9hcmNoIHsKPj4+IMKgIH07Cj4+PiDCoCBzdHJ1Y3Qga3ZtX3Zt
X3N0YXQgewo+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3ZtX3N0YXRfZ2VuZXJpYyBnZW5lcmljOwo+
Pgo+PiBzMzkwIGRvZXMgbm90IGhhdmUgcmVtb3RlX3RsYl9mbHVzaC4gSSBndWVzcyB0aGlzIGRv
ZXMgbm90IGh1cnQ/Cj4gCj4gSXQgd291bGQgaGF2ZSB0byBiZSBhY2NvdW50ZWQgaW4gZ21hcF9m
bHVzaF90bGIsIGJ1dCB0aGVyZSBpcyBubyBzdHJ1Y3Qga3ZtIGluIHRoZXJlLsKgIEEgc2xpZ2h0
bHkgaGFja2lzaCBwb3NzaWJpbGl0eSB3b3VsZCBiZSB0byBpbmNsdWRlIHRoZSBnbWFwIGJ5IHZh
bHVlIChpbnN0ZWFkIG9mIGJ5IHBvaW50ZXIpIGluIHN0cnVjdCBrdm0sIGFuZCB0aGVuIHVzZSBj
b250YWluZXJfb2YuCgpXaGF0IGlzIHRoZSBzZW1hbnRpY3Mgb2YgcmVtb3RlX3RsYl9mbHVzaD8K
Rm9yIHRoZSBob3N0OgpXZSB1c3VhbGx5IGRvIG5vdCBkbyByZW1vdGUgVExCIGZsdXNoZXMgaW4g
dGhlICJJUEkgd2l0aCBhIGZsdXNoIGV4ZWN1dGVkIG9uIHRoZSByZW1vdGUgQ1BVIiBzZW5zZS4K
V2UgZG8gaGF2ZSBpbnN0cnVjdGlvbnMgdGhhdCBpbnZhbGlkYXRlcyB0YWJsZSBlbnRyaWVzIGFu
ZCBpdCB3aWxsIHRha2UgY2FyZSBvZiByZW1vdGUgVExCcyBhcyB3ZWxsIChJUFRFIGFuZCBJRFRF
IGFuZCBDUkRURSkuClRoaXMgaXMgbmljZSwgYnV0IG9uIHRoZSBvdGhlciBzaWRlIGFuIG9wZXJh
dGluZyBzeXN0ZW0gTVVTVCB1c2UgdGhlc2UgaW5zdHJ1Y3Rpb24gaWYgdGhlIHBhZ2UgdGFibGUg
bWlnaHQgYmUgaW4gdXNlIGJ5IGFueSBDUFUuIElmIG5vdCwgeW91IGNhbiBnZXQgYSBkZWxheWVk
IGFjY2VzcyBleGNlcHRpb24gbWFjaGluZSBjaGVjayBpZiB0aGUgaGFyZHdhcmUgZGV0ZWN0IGEg
VExCL3BhZ2UgdGFibGUgaW5jb3Npc3RlbmN5LgpPbmx5IGlmIHlvdSBjYW4gZ3VhcmFudGVlIHRo
YXQgbm9ib2R5IGhhcyB0aGlzIHBhZ2UgdGFibGUgYXR0YWNoZWQgeW91IGNhbiBhbHNvIHVzZSBh
IG5vcm1hbCBzdG9yZSArIHRsYiBmbHVzaCBpbnN0cnVjdGlvbi4KCkZvciB0aGUgZ3Vlc3QgKGFu
ZCBJIGd1ZXNzIHRoYXRzIHdoYXQgd2UgY2FyZSBhYm91dCBoZXJlPykgVExCIGZsdXNoZXMgYXJl
IGFsbW9zdCBjb21wbGV0ZWx5IGhhbmRsZWQgYnkgaGFyZHdhcmUuIFRoZXJlIGlzIG9ubHkgdGhl
IHNldCBwcmVmaXggaW5zdHJ1Y3Rpb24gdGhhdCBpcyBoYW5kbGVkIGJ5IEtWTSBhbmQgdGhpcyBm
bHVzaGVzIHRoZSBjcHUgbG9jYWwgY2FjaGUuCj4gCj4gVGhpcyByZW1pbmRzIG1lIHRoYXQgSSBo
YXZlIG5ldmVyIGFza2VkIHlvdSB3aHkgdGhlIGdtYXAgY29kZSBpcyBub3QgaW4gYXJjaC9zMzkw
L2t2bSwgCgpCZWNhdXNlIHdlIHNoYXJlIHRoZSBsYXN0IGxldmVsIG9mIHRoZSBwYWdlIHRhYmxl
cyB3aXRoIHVzZXJzcGFjZSBzbyB0aGUgS1ZNIGFkZHJlc3Mgc3BhY2UgaXMgc29tZXdoYXQgdGll
ZCB0byB0aGUgdXNlciBhZGRyZXNzIHNwYWNlLgpUaGlzIGlzIHBhcnRseSBiZWNhdXNlIE1hcnRp
biB3YW50ZWQgdG8gaGF2ZSBjb250cm9sIG92ZXIgdGhpcyBkdWUgdG8gc29tZSBvZGRpdGllcyBh
Ym91dCBvdXIgcGFnZSB0YWJsZXMgYW5kIHBhcnRseSBiZWNhdXNlIG9mIHRoZSBydWxlIGZyb20g
YWJvdmUuIFVzaW5nIGEgSVBURSBvZiBzdWNoIGEgcGFnZSB0YWJsZSBlbnRyeSB3aWxsIHRha2Ug
Y2FyZSBvZiB0aGUgVExCIGVudHJpZXMgZm9yIGJvdGggKHVzZXIgYW5kIGd1ZXN0KSBtYXBwaW5n
cyBpbiBhbiBhdG9taWMgZmFzaGlvbiB3aGVuIHRoZSBwYWdlIHRhYmxlIGNoYW5nZXMuCgoKYW5k
IGFsc28gdGhhdCB0aGVyZSBpcyBubyBjb2RlIGluIFFFTVUgdGhhdCB1c2VzIEtWTV9WTV9TMzkw
X1VDT05UUk9MIG9yIEtWTV9TMzkwX1ZDUFVfRkFVTFQuwqAgSXQgd291bGQgYmUgbmljZSB0byBo
YXZlIHNvbWUgdGVzdGNhc2VzIGZvciB0aGF0LCBhbmQgYWxzbyBmb3IgS1ZNX1MzOTBfVkNQVV9G
QVVMVCB3aXRoIHJlZ3VsYXIgdmlydHVhbCBtYWNoaW5lcy4uLiBvciB0byByZW1vdmUgdGhlIGNv
ZGUgaWYgaXQncyB1bnVzZWQuCgpUaGlzIGlzIHVzZWQgYnkgYW4gaW50ZXJuYWwgZmlybXdhcmUg
dGVzdCB0b29sIHRoYXQgdXNlcyBLVk0gdG8gc3BlZWQgdXAgc2ltdWxhdGlvbiBvZiBoYXJkd2Fy
ZSBpbnN0cnVjdGlvbnMuClNlYXJjaCBmb3IgQ0VDU0lNIHRvIGdldCBhbiBpZGVhICh0aGUgZXhp
c3RpbmcgcGFwZXJzIHN0aWxsIHRhbGsgYWJvdXQgdGhlIHNhbWUgYXBwcm9hY2ggdXNpbmcgei9W
TSkuCkkgd2lsbCBjaGVjayB3aGF0IHdlIGNhbiBkbyByZWdhcmRpbmcgcmVncmVzc2lvbiB0ZXN0
cy4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
