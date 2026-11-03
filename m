Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793706384;
	b=hl3kQj+2MQnIH7O9B7j1ndFl2Bj+z/HMXyZiDFCFKm7vFZQpHq19v69MvIzAPONxe1vL
	 TOjkPzsh/q4RkqrxTgpup3C7jI9lBroTgC6H8bmw6Bz8CSGfCV90CQ683EFLb11GJT/1l
	 trSlA8aW9BmoyzceXv3RKH/9r89B68VmigO6469SZ4x/uDEa9pX4Bnez0FdSK2Gfn7Luy
	 yw+dL/tOMgPiT46laiqeZhLuaIBoB4TLsJHrVOi06H1A7PPeEWhfb5fzX6W3NZoWaxHKh
	 kxoqIC58YUHf95DPRwyH2+WQJc2cJEgEcA619HAklU9/snowrhKbKvwNdhs8aY+SuTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793706384;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=rQNgYgRzwbgahGLohNvZBfs82BLnKvw2G9BPFntd+2Y=;
	b=Rqj/LoWjKlThj4uHNLVhqrWY227Q/TQhha1KP9Lc+947k739AReiWE7IvEMtNJdRRJjD
	 A+fhyuTV4qqkRPlVzihXJiyYDME+lERvqtPTqXzmtiY7iAxVmaPPBEBMIsS3oFCTE2+mB
	 VV3xcUTtJ5ZS3hsUBjd80yy0VH1AIHbv38vsJx9HyPSGQpAJGGRONJbS7E6ij3PLBPtgF
	 75OoaWo7HkxOa1gTU26VexHMdnrzHRA09ktd2imBsvUBNgsT9uCMQSdljNHtTgWBjzT92
	 J5NFWIS1mU3IeWFwpUf3Qq+1aIB8/Ef1xMrqZgFEGy3ygsLdq9K2ceHvH94rm3pS2vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=XBPDSV6U;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AFC606A327;
	Tue,  3 Nov 2026 11:46:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41AFC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=XBPDSV6U
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3AEnqC4045893;
	Tue, 3 Nov 2026 11:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rQNgYgRzwbgahGLohNvZBfs82BLnKv
	w2G9BPFntd+2Y=; b=XBPDSV6U1ByAfT/2HXWiYPBImtoE06l1RsLvOPr+Mg1Wdg
	5bb7Q4UvH0mEeFRj51IZNVX9NifoIpA9L056gpcpDJYHk5VjyO/RQmX944rPTcqT
	lza8DMAA2sFbSnKXHJIeLKs+Q8G1+3X9B+dEQMrLtkOkjp4pNJTbzJPAiDcZXVUE
	p6Db6wAKv27p8hT6TDeMeXOr4Vk2Xpp7upRB50EYJzqoLgx5W9PMpVDKF0KnA/eX
	bnd0mHKF4Ty7FsZMzKSxZD1WU4h6XYV6jH6M4KptIOxivjveMfPtf8UA4FEmQ1NM
	hLDM5ogor5Zfi+YhNntcsukL5xZcXKcEJ/fYDveQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn80snd8h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 11:45:57 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3AK5Iq2350043;
	Tue, 3 Nov 2026 11:45:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hqbqk8stp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 11:45:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A3BjoS127460120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Nov 2026 11:45:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 770852004D;
	Tue,  3 Nov 2026 11:45:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A1B320040;
	Tue,  3 Nov 2026 11:45:49 +0000 (GMT)
Received: from osiris (unknown [9.111.24.158])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  3 Nov 2026 11:45:49 +0000 (GMT)
Date: Tue, 3 Nov 2026 12:45:48 +0100
From: Steffen Eiden <seiden@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <fuad.tabba@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, Nicholas Piggin <npiggin@gmail.com>,
        Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Teodorescu <fane@google.com>
Subject: Re: [PATCH 1/7] KVM: s390: Drop unused and unreachable
 kvm_arch_vcpu_should_kick()
Message-ID: <20261103114548.119911-B-seiden@linux.ibm.com>
References: <20261028190259.1819571-1-seanjc@google.com>
 <20261028190259.1819571-2-seanjc@google.com>
 <20261102153228.240804-H-seiden@linux.ibm.com>
 <auitiPKnFueBJzPA@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auitiPKnFueBJzPA@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: pVpgdP1XGIbnstN6hf1_H30Mry2kEc8w
X-Proofpoint-ORIG-GUID: l9khr2_nw7GEkBcFn3H6-NSEwUfuIP0C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA0NiBTYWx0ZWRfX1XmGS9lHsUL0
 R/pqFn7OS4O6sIvO6xkJJLw7ub5XYBJJ8rT4n7ytkLsrM+nXxJ8ALAk6IZ7cxaLgxzx/sz6YekU
 QUQNLzCc+AcEIzFSIIId4SI+3jZ4xWcemIVFHv+lYM846eTlTDBy/sVfsO3lwE4suzbkGudS2Kb
 gxPBGGgvMaIVdytp/A39MMoe5QDoT7CkGj5SGrkaqTAe4eTeD+SzsmTdUt/UyjY9TJC3JseqnJa
 QEo75BJzfvgqw3u+U+2wRBpyO7uPflzaZ5caj2HokpnoTurGkxzXBgpUXpjVDxTHjuBmXjI8rPa
 vxWDAmBlV9AhIXjL/sn+6LcGLT5sIIA/1vfGnxBH9hGUn2tSE9JXdCrUFdxql4RE+ZLXgJZ4H1I
 Kt9BEBx2jKRF/wavIUPm0bKdaAiukt/xqjNHAoSCxYurQjxD+KTis8S/8SmPNJktwNxtQkMBgIp
 7SZvF2lkFSgtvQ77a7g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA0NiBTYWx0ZWRfX8KXTgj3ZDXIb
 rszJKiaYCEhjwddi22AWOUixDabzaYbTZeZqW4OyLHY9z/7j8facbJ5/xv2IRGOBpQn4thL/pQY
 S1fxrlzI0e+Xs7MM8Gx7oKdd53KSVec=
X-Authority-Analysis: v=2.4 cv=FIqOVOos c=1 sm=1 tr=0 ts=6ae9c975 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=14yfDfNcGX1pIiSJYtUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030046

On Mon, Nov 02, 2026 at 07:34:32AM -0800, Sean Christopherson wrote:
> On Mon, Nov 02, 2026, Steffen Eiden wrote:
> > On Wed, Oct 28, 2026 at 12:02:53PM -0700, Sean Christopherson wrote:
> > > Drop s390's kvm_arch_vcpu_should_kick() stub as the one and only call site
> > > is wrapped with "#ifndef CONFIG_S390".
> > 
> > In the somehow near future I'll remove those #ifdefs and use the kick
> > stuff for kvm_arm64. The native s390 KVM then must at least keep an
> > (unused) symbol at hand. It seems that the compiler could not optimize
> > those calls away. So let's keep it there so I do not have to re-add it
> > soon.
> 
> Please read the rest of the series.  kvm_arch_vcpu_should_kick() goes away
> entirely.

Sorry for that. This patch just jumped to my attention and I had no time
yet to read the rest. 

	Steffen
