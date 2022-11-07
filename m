Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E02C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:51:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11AC44BB6B;
	Thu, 10 Nov 2022 09:51:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VWb-Ox7lnzCW; Thu, 10 Nov 2022 09:51:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C72C4BB23;
	Thu, 10 Nov 2022 09:51:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 490244B87C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:57:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UCnXSQWC9tgx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 12:57:38 -0500 (EST)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D352D4B868
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:57:38 -0500 (EST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7GWJ3q025033;
 Mon, 7 Nov 2022 17:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=f/VyMxldYSSF3j2oK7NPGa3PSNeBgbkNFvcSuG+2vx0=;
 b=S/OmHIKl6xk3e5DTWJwBRHY4lzU49Rc8ZGVwoj57UADrowOK07/esILhX51XvfJdOMXr
 mGyQ+AfwLDXvZLh6Y9AXiwN7sJ7f03jvlfn8cP2lyWNruJtWNqei483yk5/BJuN/WUE4
 +gww4sppA6zPjXCHUAJaLGlfBRtvSFJfa/dLDmf24cRnkgeaih1LzugmsJlZ7fMHhd5A
 ac8WW8nmTO1n8QaI/YhrR898ZaXXwP3xILX1k0Zz4zJaLt+cgarxEXI7olJSehWyz89k
 7VgnIOaxNZTBYMVZSWT0rjhsgcdrdPWr4gKgulZ3e0kr7jg6dJBNUiMelAsjUsixhgYP XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1gmcfya-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 17:56:58 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7GfRN3013181;
 Mon, 7 Nov 2022 17:56:57 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com
 [169.63.121.186])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1gmcfxr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 17:56:57 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
 by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7Hpg97017981;
 Mon, 7 Nov 2022 17:56:56 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com
 (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
 by ppma03wdc.us.ibm.com with ESMTP id 3kngs717x9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 17:56:56 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
 by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 2A7Huq9X25494124
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 7 Nov 2022 17:56:53 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id CC5055805E;
 Mon,  7 Nov 2022 17:56:54 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id B470A5805F;
 Mon,  7 Nov 2022 17:56:51 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown
 [9.65.225.56]) by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
 Mon,  7 Nov 2022 17:56:51 +0000 (GMT)
Message-ID: <5e44854b2781a0be6fae5c82645ac64ef9b5dccf.camel@linux.ibm.com>
Subject: Re: [PATCH 04/44] KVM: Teardown VFIO ops earlier in kvm_exit()
From: Eric Farman <farman@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, Paul
 Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Matthew Rosato
 <mjrosato@linux.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Mon, 07 Nov 2022 12:56:51 -0500
In-Reply-To: <20221102231911.3107438-5-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-5-seanjc@google.com>
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lZlTwgd7mrqbECRxIjDdrL-RNnawny2B
X-Proofpoint-GUID: bMDCUJB8k6cbTpkwMsak__06bTu4RXWC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070140
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gV2VkLCAyMDIyLTExLTAyIGF0IDIzOjE4ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOgo+IE1vdmUgdGhlIGNhbGwgdG8ga3ZtX3ZmaW9fb3BzX2V4aXQoKSBmdXJ0aGVyIHVwIGt2
bV9leGl0KCkgdG8gdHJ5IGFuZAo+IGJyaW5nIHNvbWUgYW1vdW50IG9mIHN5bW1ldHJ5IHRvIHRo
ZSBzZXR1cCBvcmRlciBpbiBrdm1faW5pdCgpLCBhbmQKPiBtb3JlCj4gaW1wb3J0YW50bHkgc28g
dGhhdCB0aGUgYXJjaCBob29rcyBhcmUgaW52b2tlZCBkZWFkIGxhc3QgYnkKPiBrdm1fZXhpdCgp
Lgo+IFRoaXMgd2lsbCBhbGxvdyBhcmNoIGNvZGUgdG8gbW92ZSBhd2F5IGZyb20gdGhlIGFyY2gg
aG9va3Mgd2l0aG91dAo+IGFueQo+IGNoYW5nZSBpbiBvcmRlcmluZyBiZXR3ZWVuIGFyY2ggY29k
ZSBhbmQgY29tbW9uIGNvZGUgaW4ga3ZtX2V4aXQoKS4KPiAKPiBUaGF0IGt2bV92ZmlvX29wc19l
eGl0KCkgaXMgY2FsbGVkIGxhc3QgYXBwZWFycyB0byBiZSAxMDAlCj4gYXJiaXRyYXJ5LsKgIEl0
Cj4gd2FzIGJvbHRlZCBvbiBhZnRlciB0aGUgZmFjdCBieSBjb21taXQgNTcxZWUxYjY4NTk4ICgi
a3ZtOiB2ZmlvOiBmaXgKPiB1bnJlZ2lzdGVyIGt2bV9kZXZpY2Vfb3BzIG9mIHZmaW8iKS7CoCBU
aGUgbnVsbGlmaWVkCj4ga3ZtX2RldmljZV9vcHNfdGFibGUKPiBpcyBhbHNvIGxvY2FsIHRvIGt2
bV9tYWluLmMgYW5kIGlzIHVzZWQgb25seSB3aGVuIHRoZXJlIGFyZSBhY3RpdmUKPiBWTXMsCj4g
c28gdW5sZXNzIGFyY2ggY29kZSBpcyBkb2luZyBzb21ldGhpbmcgdHJ1bHkgYml6YXJyZSwgbnVs
bGlmeWluZyB0aGUKPiB0YWJsZSBlYXJsaWVyIGluIGt2bV9leGl0KCkgaXMgbGl0dGxlIG1vcmUg
dGhhbiBhIG5vcC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4KPiAtLS0KPiDCoHZpcnQva3ZtL2t2bV9tYWluLmMgfCAyICstCj4gwqAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKClJldmlld2VkLWJ5
OiBFcmljIEZhcm1hbiA8ZmFybWFuQGxpbnV4LmlibS5jb20+Cl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
