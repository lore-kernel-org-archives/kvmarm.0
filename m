Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B97C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:51:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 514C74BAC0;
	Thu, 10 Nov 2022 09:51:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8-mcN8upMiPi; Thu, 10 Nov 2022 09:51:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 763734BB3A;
	Thu, 10 Nov 2022 09:51:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95DAC4B86D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:22:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y7J80cYBEZQO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 13:22:48 -0500 (EST)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61C084B866
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:22:48 -0500 (EST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7IBfhG003607;
 Mon, 7 Nov 2022 18:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=EzR8gIJXN5CxUQRbcB4MiNn9dtOoco2fyNz/1FbCYTs=;
 b=oLSyj97Tdsnk0VQOOelX0cMC03SHso5gNnzaHyD+AU0QdK4ObvkSGhKy5MB3Eu0X4nH3
 cwQlVJnBR+mHedqllHCGkozoyH6XI3rvXWzRd6B14keKEVzxvN6OwiPguQYiPjgoozr5
 CuCksG6s9mdmq7QLIUQJIca83ZvoD2XgDSxzv6A51X5fRtxNeiKKljGLcDn9w2C0oVaI
 lt4UbjIbWAu4ejWPW7Tu9j/0mFdDdf2RJQ//Gs+6w72ns70J8ekHGYyOg0A6bX47zuXl
 7JNyzQw/vMhVPkpKIf+E0zSFCsOlxjnE+4eVRtOOT/s/U0hkUCCpuH99DScbFKpRAn6z EA== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1uuwfy4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 18:22:19 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7Gap8F020063;
 Mon, 7 Nov 2022 18:22:18 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com
 [169.53.41.122])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1uuwfxe-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 18:22:17 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
 by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7IL2nI028450;
 Mon, 7 Nov 2022 18:22:16 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com
 (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
 by ppma04dal.us.ibm.com with ESMTP id 3kngmswr5v-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 18:22:16 +0000
Received: from smtpav04.dal12v.mail.ibm.com ([9.208.128.131])
 by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 2A7IMJ895243508
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 7 Nov 2022 18:22:19 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id B096858062;
 Mon,  7 Nov 2022 18:22:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id E657058052;
 Mon,  7 Nov 2022 18:22:11 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown
 [9.65.225.56]) by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
 Mon,  7 Nov 2022 18:22:11 +0000 (GMT)
Message-ID: <e2b21ebfec94bcc3d830a5c7f11837d6dedac652.camel@linux.ibm.com>
Subject: Re: [PATCH 25/44] KVM: s390: Do s390 specific init without bouncing
 through kvm_init()
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
Date: Mon, 07 Nov 2022 13:22:11 -0500
In-Reply-To: <20221102231911.3107438-26-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-26-seanjc@google.com>
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zz_sQx9dIUW7WUoiYMvv3aj8CVyX61yu
X-Proofpoint-ORIG-GUID: x0YF0w8yQ2jwBDgCwuGa40JfBxQPUq9F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0
 mlxlogscore=598 clxscore=1015 impostorscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070144
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
b3RlOgo+IE1vdmUgdGhlIGd1dHMgb2Yga3ZtX2FyY2hfaW5pdCgpIGludG8gYSBuZXcgaGVscGVy
LAo+IF9fa3ZtX3MzOTBfaW5pdCgpLAo+IGFuZCBpbnZva2UgdGhlIG5ldyBoZWxwZXIgZGlyZWN0
bHkgZnJvbSBrdm1fczM5MF9pbml0KCkgaW5zdGVhZCBvZgo+IGJvdW5jaW5nIHRocm91Z2gga3Zt
X2luaXQoKS7CoCBJbnZva2luZyBrdm1fYXJjaF9pbml0KCkgaXMgdGhlIHZlcnkKPiBmaXJzdCBh
Y3Rpb24gcGVyZm9ybWVkIGJ5IGt2bV9pbml0KCksIGkuZS4gdGhpcyBpcyBhIGdsb3JpZmllZCBu
b3AuCj4gCj4gTW92aW5nIHNldHVwIHRvIF9fa3ZtX3MzOTBfaW5pdCgpIHdpbGwgYWxsb3cgdGFn
Z2luZyBtb3JlIGZ1bmN0aW9ucwo+IGFzCj4gX19pbml0LCBhbmQgZW1wdHlpbmcga3ZtX2FyY2hf
aW5pdCgpIHdpbGwgYWxsb3cgZHJvcHBpbmcgdGhlIGhvb2sKPiBlbnRpcmVseSBvbmNlIGFsbCBh
cmNoaXRlY3R1cmUgaW1wbGVtZW50YXRpb25zIGFyZSBub3BzLgo+IAo+IE5vIGZ1bmN0aW9uYWwg
Y2hhbmdlIGludGVuZGVkLgo+IAo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPgo+IC0tLQo+IMKgYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jIHwg
MjkgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyNSBp
bnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKUmV2aWV3ZWQtYnk6IEVyaWMgRmFybWFuIDxm
YXJtYW5AbGludXguaWJtLmNvbT4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
