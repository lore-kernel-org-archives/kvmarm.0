Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8CFC43219
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:51:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8A94BB86;
	Thu, 10 Nov 2022 09:51:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TRhN0VcsQ4fA; Thu, 10 Nov 2022 09:51:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C881C4BB2C;
	Thu, 10 Nov 2022 09:51:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 932FE4B87C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:58:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0o-DS80cFZdS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 12:58:18 -0500 (EST)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EC484B868
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:58:17 -0500 (EST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7GwDic011947;
 Mon, 7 Nov 2022 17:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YihfQm6JRpW3FFMAWPS/MkEOkqiW/lbLXXaGSks5I5Y=;
 b=RmD9JtKvUg9mHfb6CMoDoiJwC4LwdRkwwMPnUP0+ML3lsvjLRm5m1SxYiMb3WRhYQFk0
 VVTpLv10dzML14PzTxA17a+meZi9SVZlmkNg/nNXWorX1oVwSU05SmVRYjq76jbrEwe7
 ix+v4arhKFwHnLT5ZzI7WGnJm5nL1eaZZIYSXxqgmKN3lhZIF5Aez2YyK2FLT2o3PvCa
 P4/4GWhyQ1jb6gNiyeSCtYeSAXD38BT8KoUps434p/v3mRFsfpmY4GruA8/z9GDigjvt
 JesjjGdkEkLL7eNvk3XJ78eYdrhitHcx3p7SiQxW6u1SuwPxBdPqwR1FSz3X1CM/pw/Z ag== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp14xc29y-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 17:57:25 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7GAU5a024872;
 Mon, 7 Nov 2022 17:57:24 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com
 [169.62.189.11])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp14xc296-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 17:57:24 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
 by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7Hotxo017059;
 Mon, 7 Nov 2022 17:57:23 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com
 (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
 by ppma03dal.us.ibm.com with ESMTP id 3kngphwhp0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 17:57:23 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
 by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 2A7HvI5v35914384
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 7 Nov 2022 17:57:18 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 38E3658062;
 Mon,  7 Nov 2022 17:57:21 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 1971F58059;
 Mon,  7 Nov 2022 17:57:18 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown
 [9.65.225.56]) by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
 Mon,  7 Nov 2022 17:57:17 +0000 (GMT)
Message-ID: <1386ccd1ff60cb8e4af80fbb294160a8d7cc3b5b.camel@linux.ibm.com>
Subject: Re: [PATCH 05/44] KVM: s390: Unwind kvm_arch_init()
 piece-by-piece() if a step fails
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
Date: Mon, 07 Nov 2022 12:57:17 -0500
In-Reply-To: <20221102231911.3107438-6-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-6-seanjc@google.com>
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x0CFSwe6XYz-Xhj4j-0SH7l6f0V92YqI
X-Proofpoint-GUID: 6DNbjcvPaQN4ZD-vbbGxEV1nmcCcrdiP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
b3RlOgo+IEluIHByZXBhcmF0aW9uIGZvciBmb2xkaW5nIGt2bV9hcmNoX2hhcmR3YXJlX3NldHVw
KCkgaW50bwo+IGt2bV9hcmNoX2luaXQoKSwKPiB1bndpbmQgaW5pdGlhbGl6YXRpb24gb25lIHN0
ZXAgYXQgYSB0aW1lIGluc3RlYWQgb2Ygc2ltcGx5IGNhbGxpbmcKPiBrdm1fYXJjaF9leGl0KCku
wqAgVXNpbmcga3ZtX2FyY2hfZXhpdCgpIHJlZ2FyZGxlc3Mgb2Ygd2hpY2gKPiBpbml0aWFsaXph
dGlvbgo+IHN0ZXAgZmFpbGVkIHJlbGllcyBvbiBhbGwgYWZmZWN0ZWQgc3RhdGUgcGxheWluZyBu
aWNlIHdpdGggYmVpbmcKPiB1bmRvbmUKPiBldmVuIGlmIHNhaWQgc3RhdGUgd2Fzbid0IGZpcnN0
IHNldHVwLsKgIFRoYXQgaG9sZHMgdHJ1ZSBmb3Igc3RhdGUKPiB0aGF0IGlzCj4gY3VycmVudGx5
IGNvbmZpZ3VyZWQgYnkga3ZtX2FyY2hfaW5pdCgpLCBidXQgbm90IGZvciBzdGF0ZSB0aGF0J3MK
PiBoYW5kbGVkCj4gYnkga3ZtX2FyY2hfaGFyZHdhcmVfc2V0dXAoKSwgZS5nLiBjYWxsaW5nCj4g
Z21hcF91bnJlZ2lzdGVyX3B0ZV9ub3RpZmllcigpCj4gd2l0aG91dCBmaXJzdCByZWdpc3Rlcmlu
ZyBhIG5vdGlmaWVyIHdvdWxkIHJlc3VsdCBpbiBsaXN0IGNvcnJ1cHRpb24KPiBkdWUKPiB0byBh
dHRlbXB0aW5nIHRvIGRlbGV0ZSBhbiBlbnRyeSB0aGF0IHdhcyBuZXZlciBhZGRlZCB0byB0aGUg
bGlzdC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4KPiAtLS0KPiDCoGFyY2gvczM5MC9rdm0va3ZtLXMzOTAuYyB8IDIxICsrKysrKysr
KysrKysrLS0tLS0tLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDcgZGVs
ZXRpb25zKC0pCgpSZXZpZXdlZC1ieTogRXJpYyBGYXJtYW4gPGZhcm1hbkBsaW51eC5pYm0uY29t
PgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
