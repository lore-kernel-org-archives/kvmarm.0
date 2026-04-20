Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC3721CC5C
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 11:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776684427; cv=none; b=ZLpxarLnZjhjGdeey7HSd0STfbPy511NWBRxOY36meCRHrWvh9ie+XmWAWuCrZQaI7mu/GVa9TbyygAfBpkoO+o0ZskzJWdsFKL7ZrQQMPcuVfMxnnTC3scZ7LtJkHi0I/t6BW3xiELBZ/yJXf32eeAe4J4mS1bcqvT0Q7Fy5Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776684427; c=relaxed/simple;
	bh=EAIBkwfHAclHv82qFqqZgfbH7oy+jWtj3/CdLgBXY+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLWkHJ5sS2DSbEENkcvnhzsv5/i2oxDnS/w0wR1zNSO6c1BGQy7DRtfa1+UZ0+jkL5V7iZ7jDVgmhwCnF6bdC/bXTYU8tjWXGNGocn4F+/LblC3UBhQ8vCTESnv3iHUqdfuEU4aFpo2f6+Nhsi2QqKWDkuhJDuodo8iRcwBEwSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SVQMKQw5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D4zGEQbE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SVQMKQw5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D4zGEQbE"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KA4FPO2980857
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 11:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=PsndaJhCTCpTmO1OsNUkW3V3
	Ph6eGaHFsklZOAPJF0M=; b=SVQMKQw5/aErfOq8H1vTpTAoNI7Lb8O8VZtzRnvX
	j3Zk1xM2VnerLb6ywQCXKerO0Zb5Xqoom6oo4Oh4sRB4gj42XYjTCrTgC9idlZEr
	6HUPCxuCrlewjfK5igmpUZ3pLsefFZ0ADA8osYtloWJJJCZHTHY00hWnkV+6R5bJ
	Dp5asdJ1W7iFMXMRgbf10xOTMxDNccqNMru1mG2ghul5kjaLvs+pKxeMQdUEKKl5
	NLTw3Y7RvWJGj8hRnUTiLjLmrFDlxbTL1OhuOmMDf1Xc/kfdtioxQQx9YazoZCwO
	b91XbV1zfVhyJ1/Fc851r3csLbUCMlOC6cXwljeLQaRhog==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnj2pr85k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 11:27:05 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3568090851aso6794786a91.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 04:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776684425; x=1777289225; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsndaJhCTCpTmO1OsNUkW3V3Ph6eGaHFsklZOAPJF0M=;
        b=D4zGEQbEkxBrf1p2p8Lf5NfqovhlawAo/JagQR/HH/ZyU6e/qYicWa/cSP7mBBkp9k
         d43YiWXXCC5aJEpAhsu+CiPastoG0Ai1JBWxb2ZU8Xx37PlnIGCDmTEXt7Wc4gE2sJ1t
         CtoY6CMhvlgL7iCP0kSB5rE0UuOe3i4jG2611NAwtBNQTMAUoFBaiHuffZP3PV0XxJsT
         w4QmMQzQXgOHjOQ/t9bIVI3px5Oev6a087uBQPX/tauTudQUSdrnYyxApCRubIpO/TMt
         t9Zn+O1Jvh1FCHBFHSXK7o3OjAEw4eS91ie1FP3iJ1XyZhGt7/OpIg+dSfstmWuqWd08
         lN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776684425; x=1777289225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PsndaJhCTCpTmO1OsNUkW3V3Ph6eGaHFsklZOAPJF0M=;
        b=SiPi7tHTC6URuaseGU/cYMOmI8wPZGS9myQxCFZ4c+gDWJ5M0x9HdSD0UPayPePcSJ
         xRNhr6PMKLd+WO/tV0Kzt0+ghgDti6C1gH/kVhaLA9TVBTgtCjqY3yTnuLLczR/dELKX
         E/sgUhc3UXkmA8y9+c6N49a6QKwAVk0i62NOVv8FwcHFWRvsOk/e/Y+h4MX7lqm79CIa
         ND7X2xOHiKLutcfl9rEgIc6DD3iJL6W8tLdkbx9WR0MWgK5yi0CpdKFIQye5jEfLXsHo
         IIjNCULYSb5sseneMM3clMj12tZQn4k2Hb2xO7zY9Et4KaqapOT6Huic8OM3OyurdhMj
         wh2Q==
X-Forwarded-Encrypted: i=1; AFNElJ+IDKBpWxf5h5HE6XlsjZmw5CZRa51H7G//MkOZcGNfbGTCXvk3YLz2hzhXaCwYjQo3YWUhMUE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxU1XUu2Uzy9W+mdN3BtBvC14zhsVfcPN1sAY/VQ2dvuDtVfCoI
	iJ9nHrJLYodqrTdFoDHB1iks6Q7ig/9oC6PpxGe++Nw+mYL7BfNX5ZAVIVB0AVIB0ez/nC5G8De
	sjEAOvrel7CxoVK1YdSDJNQCYf+aF0MR0t+jT5WkONmorChjUDlFskzK7lCM=
X-Gm-Gg: AeBDieszzQrXdt5xvDoeUKHv27Y/5LAr7h/1Y7a+KVnOj8/AWimngkzq3MW3wSyQO26
	hPIsMa23kXzuvzp/Ls02llSo1k8pHOEyJ4LWy3vbX+sc3zEmnuyTZZfK5RC0dZgS/uonnBzgQ/U
	QZda5f+3yUuAZEGDRhMm5jPqeBYG9t8UVKlN9hGuzF3vlorOC2Hl6c50UGSFcj7NmS5PArrWvFL
	B475T+gK2uFOy+J98imSEV0FoP58V0/TyLeV6MVQwp/erBCaWk7w3Yh9Sek/AZNzwEVjbM6NDws
	ZjRU2Gd6StEqNyBXqB9ug4VwYw5gnnlQb7VGqI2/VmH9CPBEi9sI9htwt9sSdsYCXsbBnrtvvmj
	FzzV6YHFAOQXIp0fjoVKlcZqYvVaqkXd3fEM/GjrcSzbzwdtwhuV3J+tWP2QKUaHTnQ==
X-Received: by 2002:a17:90b:1807:b0:35f:bb33:d728 with SMTP id 98e67ed59e1d1-361403f2bd5mr14890489a91.11.1776684424685;
        Mon, 20 Apr 2026 04:27:04 -0700 (PDT)
X-Received: by 2002:a17:90b:1807:b0:35f:bb33:d728 with SMTP id 98e67ed59e1d1-361403f2bd5mr14890454a91.11.1776684424211;
        Mon, 20 Apr 2026 04:27:04 -0700 (PDT)
Received: from hu-pkondeti-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fbd470fsm3981614a91.12.2026.04.20.04.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 04:27:03 -0700 (PDT)
Date: Mon, 20 Apr 2026 16:56:57 +0530
From: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
To: Will Deacon <will@kernel.org>
Cc: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 00/30] KVM: arm64: Add support for protected guest memory
 with pKVM
Message-ID: <573483a8-7cb7-479f-a96d-67416ef1f6db@quicinc.com>
References: <20260105154939.11041-1-will@kernel.org>
 <3f52367b-f927-4d4d-9df3-bcd8cd954d47@quicinc.com>
 <aeX5Q7QNxmBCmsqM@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeX5Q7QNxmBCmsqM@willie-the-truck>
X-Proofpoint-ORIG-GUID: 5gfeULRJFyr-hiETPQMzIbimCMFxTyVD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDExMSBTYWx0ZWRfX9Asi4LHLlAX/
 SbZb2K3O5AZDGX5Jyp4m4W/Rrhwj4BjpmyUEn2RE/72ZSyVu+S5ESDy1J2s4LinF45EJyD40CS1
 +SHhbneBJvywU6SYzMakYvuoHjmR4LqAqSl7rYSS2udhNyzEZrsAjcO3IEkhsFKU/RHfGZrSF47
 pvtFTAFWBBVcjJujYSdkYoU5zPM8mSnWnioWG6IRhuElANZsEoXOPi0iBd7FTThuxRVb9ytNuyX
 MDCD9tj6aFTdKFL9Y7CMjpz+NcHxOlF0woH8SL4TDuTX0Rn9enCD7Qf94ZSrDZAyiqGI8W6reN7
 +5mk9kMfhPI+qa4hc7yOFBa+Cc2UCR4Kso/W61TqegNTuIzRkimkFPErooqgXz++IBVqIxUj2O3
 fiGujzzxDyIKs7R865I8ykPk/k5C+/m2T/ZNWleG4bNEfB/cgjAfj8/gOOk4CRA+ITRFb2zxX28
 3dGBMzQCi/dXZ+3pKnQ==
X-Authority-Analysis: v=2.4 cv=XMoAjwhE c=1 sm=1 tr=0 ts=69e60d89 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=vggBfdFIAAAA:8 a=KSvv7RmM8nE5zw0GlVcA:9
 a=CjuIK1q_8ugA:10 a=uKXjsCUrEbL0IQVhDsJ9:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 5gfeULRJFyr-hiETPQMzIbimCMFxTyVD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604200111

On Mon, Apr 20, 2026 at 11:00:35AM +0100, Will Deacon wrote:
> On Mon, Apr 20, 2026 at 01:32:03PM +0530, Pavan Kondeti wrote:
> > Hi Will,
> > 
> > On Mon, Jan 05, 2026 at 03:49:08PM +0000, Will Deacon wrote:
> > > Hi folks,
> > > 
> > > Although pKVM has been shipping in Android kernels for a while now,
> > > protected guest (pVM) support has been somewhat languishing upstream.
> > > This has partly been because we've been waiting for guest_memfd() but
> > > also because it hasn't been clear how to expose pVMs to userspace (which
> > > is necessary for testing) without getting everything in place beforehand.
> > > This has led to frustration on both sides of the fence [1] and so this
> > > patch series attempts to get things moving again by exposing pVM
> > > features in an incremental fashion based on top of anonymous memory,
> > > which is what we have been using in Android. The big difference between
> > > this series and the Android implementation is the graceful handling of
> > > host stage-2 faults arising from accesses made using kernel mappings.
> > > The hope is that this will unblock pKVM upstreaming efforts while the
> > > guest_memfd() work continues to evolve.
> > > 
> > > Specifically, this patch series implements support for protected guest
> > > memory with pKVM, where pages are unmapped from the host as they are
> > > faulted into the guest and can be shared back from the guest using pKVM
> > > hypercalls. Protected guests are created using a new machine type
> > > identifier and can be booted to a shell using the kvmtool patches
> > > available at [2], which finally means that we are able to test the pVM
> > > logic in pKVM. Since this is an incremental step towards full isolation
> > > from the host (for example, the CPU register state and DMA accesses are
> > > not yet isolated), creating a pVM requires a developer Kconfig option to
> > > be enabled in addition to booting with 'kvm-arm.mode=protected' and
> > > results in a kernel taint.
> > > 
> > 
> > Good to see Protected VM support in upstream w/ pKVM.
> > 
> > We (Qualcomm) have been trying to resume Gunyah upstreaming [1] efforts 
> > for some time but the path to re-use guest_memfd is not straight forward as
> > guest_memfd is tightly coupled with KVM. While the efforts to use it for
> > pKVM is pending and refactoring to make it use outside KVM is not
> > happening anytime soon, we plan to send Gunyah series similar to how
> > this series is dealt with pages lent/donated to the Guest. Please let us
> > know if you have any suggestions/comments for us.
> 
> The major problem I see with this is that the host/hyp interface for
> handling stage-2 faults is internal to pKVM. The exception is injected
> back into the host using a funky ESR encoding and the hypercall used
> to forcefully reclaim the page is not ABI. I have no appetite for
> standardising these mechanisms (the flexibility is one of pKVM's big
> advantages) but I also do not want to complicate EL1 fault handling path
> with hypervisor-specific crap that we have to maintain forever.

Thanks Will for the feedback. Agree that we don't want to sprinkle Gunyah
specific checks in fault handling code. Do we need to handle anything
apart from

(a) user space access a memory that is lent to the guest. Gunyah will 
inject Synchronous External Abort and the offending process will be killed.

(b) For kernel access, we need to unmap the memory at S1 while lending
it to the guest. Earlier, Elliot attempted this with [1]. I am thinking
we can leverage from Direct map removal work done for guest_memfd w/o
really using it :-) . I am hoping [2] can be made available for Gunyah
module as well.

For the (b) problem above, pKVM takes a different route in upstream i.e
pkvm_force_reclaim_guest_page(). I believe this avoids kernel panic at 
the expense of memory corruption in the guest. correct?

Thanks,
Pavan

[1]
https://lore.kernel.org/all/20240222-gunyah-v17-19-1e9da6763d38@quicinc.com/
[2]
https://lore.kernel.org/all/20260317141031.514-3-kalyazin@amazon.com/
