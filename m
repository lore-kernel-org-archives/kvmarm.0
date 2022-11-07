Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38598C43219
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:51:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E48114BB3C;
	Thu, 10 Nov 2022 09:51:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gbMDDurb+OKG; Thu, 10 Nov 2022 09:51:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51ABB4BB37;
	Thu, 10 Nov 2022 09:51:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E16DD4B866
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:22:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WJCgT36EdxeX for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 13:22:43 -0500 (EST)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABA4D4B862
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:22:43 -0500 (EST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7IHnXe003378;
 Mon, 7 Nov 2022 18:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ZuH7o3e1bTbqF+x/vFxtjEWKRRIInbJqe4eNJNa0mb8=;
 b=ju7oucrH6Wp8iBVMxTmB6zAqvCw5YC+Uz7+ezSttCHZ8sxH5CWUu8XcZDONE680ltY18
 IM0/sU73Ux/BfEYs2jpjh/I9DGAs7CeQgxtnwDe0q0OC2l6txXGHl+ii6qvFMBe5LJHn
 xvP9Fdts1GQVXda4zUeOWS20cLGW++8Rjn4VbpDidij1biZGQ9wYJ6QmZ1QKVxQAvzVL
 kEsRyFS+Cs/8s6a2TvHL3qC59PCKR1kEj1kES2YRh2guwZnT239IkfuhFri5PcBlb2Zc
 gNdgvxDVS5jfSMiDjUQWZOLmInbeGJHVf/3yrd5m8sqajqV1nNPploHPbvQ8vPv6UuCt Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1uuwg4d-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 18:22:28 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7HQmcs001764;
 Mon, 7 Nov 2022 18:22:27 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com
 [169.63.214.131])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1uuwg3j-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 18:22:27 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
 by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7IMEBr024052;
 Mon, 7 Nov 2022 18:22:25 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com
 [9.57.198.26]) by ppma01dal.us.ibm.com with ESMTP id 3kngsxwpkr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 18:22:25 +0000
Received: from smtpav04.wdc07v.mail.ibm.com ([9.208.128.116])
 by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 2A7IMOUX22217242
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 7 Nov 2022 18:22:24 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id DCA1258050;
 Mon,  7 Nov 2022 18:22:23 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id CD03058062;
 Mon,  7 Nov 2022 18:22:19 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown
 [9.65.225.56]) by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
 Mon,  7 Nov 2022 18:22:19 +0000 (GMT)
Message-ID: <fb45be96446d9d66272eafe284863f80bac8af45.camel@linux.ibm.com>
Subject: Re: [PATCH 26/44] KVM: s390: Mark __kvm_s390_init() and its
 descendants as __init
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
Date: Mon, 07 Nov 2022 13:22:19 -0500
In-Reply-To: <20221102231911.3107438-27-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-27-seanjc@google.com>
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _6IU7V4dMFctPdA56pgQtBe5YtzLgS6A
X-Proofpoint-ORIG-GUID: V82sdblhujvxGzoxMA2V1e4qIeYYLGgb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0
 mlxlogscore=908 clxscore=1015 impostorscore=0 malwarescore=0
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
b3RlOgo+IFRhZyBfX2t2bV9zMzkwX2luaXQoKSBhbmQgaXRzIHVuaXF1ZSBoZWxwZXJzIGFzIF9f
aW5pdC7CoCBUaGVzZQo+IGZ1bmN0aW9ucwo+IGFyZSBvbmx5IGV2ZXIgY2FsbGVkIGR1cmluZyBt
b2R1bGVfaW5pdCgpLCBidXQgY291bGQgbm90IGJlIHRhZ2dlZAo+IGFjY29yZGluZ2x5IHdoaWxl
IHRoZXkgd2VyZSBpbnZva2VkIGZyb20gdGhlIGNvbW1vbiBrdm1fYXJjaF9pbml0KCksCj4gd2hp
Y2ggaXMgbm90IF9faW5pdCBiZWNhdXNlIG9mIHg4Ni4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFu
IENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4KPiAtLS0KPiDCoGFyY2gvczM5MC9r
dm0vaW50ZXJydXB0LmMgfCAyICstCj4gwqBhcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmPCoCB8IDQg
KystLQo+IMKgYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5owqAgfCAyICstCj4gwqBhcmNoL3MzOTAv
a3ZtL3BjaS5jwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgYXJjaC9zMzkwL2t2bS9wY2kuaMKgwqDC
oMKgwqDCoCB8IDIgKy0KPiDCoDUgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRl
bGV0aW9ucygtKQoKUmV2aWV3ZWQtYnk6IEVyaWMgRmFybWFuIDxmYXJtYW5AbGludXguaWJtLmNv
bT4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
