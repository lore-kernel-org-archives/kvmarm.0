Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AF2286417
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 04:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776744958; cv=none; b=YVmbHFmL63M9uJ4OCtsEHzzIwS/EHcSnRtaoKaQvD46xyGDho9ka5pX25N1n3U+aTS1sILaxz1yoEbaSpIyTrpoSsp6HkBSXxvdtVKRwSosDMPLkO44K+XZOkZDNjfDR3wm1TExZOm7d4goS7JjQqYDBAJa4VHyInNH+V9QKZT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776744958; c=relaxed/simple;
	bh=8fOeJTGzRqiCDOwgRrZNZHXdv+JFxWK0TE4/7FWtvOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkCDUrEdz5dgy1g3dr4CFl8mNs3Op2tCkGspsHyKSdove17ZtjCa64aeaoc8CDr/4himT41WTAOP/2fxkZBYm5lbn6vEQHLLKrichdTfi4fsQl2BnSElUPTcWX0wOSFmzXGAKzNuNMuSUh5D6GZWSz7Iw8/NU8L9F86FOodrwJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YYFcdhbR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V9XPFjQW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YYFcdhbR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V9XPFjQW"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63L2PTPi2980856
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 04:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=RkGFo2uls78DCBvdk/ApDVoQ
	+XtuJ02VYs5MSe2EIU8=; b=YYFcdhbRBYMXcne12sxl6IN5FLxgBqeweC4iERHj
	BpXUyaceCgBvEmUR6SdxgiuZRhjTDPtpn2Pg584U40CiDkUFpHLYgisdDXtboYzb
	6e5mMFtPDjgBx8e2CHER5JSTQ1AUzeDxrBXUN1/GWWPluRr5Fb0p8ngNmtmloxhG
	BY02jhyqnqw61pddvt30LPS/fRt/YIb6kOQPItNfUccspaw3QjtX/T2+I63Q24YL
	SZyT7EBfC+191scbiXZjH8tX4KGuxw377/VMC2IMXrbxbesezEZb6MtbhXxwA4Qn
	fMFvamc6rjMbDS2TjS5lyz26C40SevSpep33JmZb+/yFCQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnj2pudmx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 04:15:55 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c797efdaa9cso1477171a12.3
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776744954; x=1777349754; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RkGFo2uls78DCBvdk/ApDVoQ+XtuJ02VYs5MSe2EIU8=;
        b=V9XPFjQWmD4Ha4UVTOyNLD9qgOwCrLRxSLcCsO9ZaKDuIBhq3KzDdV0blAFNyDxC43
         RuOETvdR2G0EBw0NoKEJeWNPY/dPO3Ba8xoZihr59QW12J9dC83xqo0xiRUTonUR3zTK
         U6/GHDx4YZlZEKf5RGBlE3Swz21hvWPOl580m3gRwFUz8mxkAmyyaxflczl8804llfac
         +1djx6WpoKV9HLRPxuRpwryq/4r3zJzqtd1WdH3/0QfyBbLYkxAy/3RDmPv5Arlgr7VL
         jZQc9KxcxcO+3LJCLhYHjocEuBU8Hq6IKgLmD3zlj+7520TVF4FRjb4wCMyP36Q90w1e
         s0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776744954; x=1777349754;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RkGFo2uls78DCBvdk/ApDVoQ+XtuJ02VYs5MSe2EIU8=;
        b=P6gZJbSuflbLxZIMLsjf6MtywxrvvbsmNA9wlgtSW2FYCab61G4gK96kmxpp79rLOM
         LeSxAKzo3q9NtMRGJQr28D7Y/c0Kxwk7SrfA9bzk4o4WAAYI6Tp2txk6bS81EsVZUC/J
         HX/Onk5NpoCbqq1r1ogzWYyWKbET/4zkTRcf813OOuzxc4hcBdNensjrrbOBMJHcCC54
         eNBi5wLEbxWiBcRWlmZ670ZZAbuoZgYD+rvNU/r5v3/Inibv+nMAlvIS+d4EDsIKuXSq
         Iq4pfJzlnyLeXSdRsnMxa2rugNMDLIYVOr8fHHF1h7d5CeCyobo7rviu+yVI1cUiDLDW
         PXLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8byKR1E6POBq8zQgJxhKyQw106iUcSZYdaSlImhl31ErqHcFjJW8dEocmSMSrEyTwFQNzJLyk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzteAdvNJUnPoxEDergd4hkzqFul82auOG02ajAuCm4iu2Z8Pth
	rrox7wWkIBcJbFfRF+qkVc/B0cR7/h9Q/O6bqIeDxVfutcojRcHSD8AzuOawqGQVhPcddwfxYlo
	eT3Nfcs2XoP+apDCZMlvZOHYyMAb7lTLOsSjJFHCMPX6JM6rC10Ispg6VheA=
X-Gm-Gg: AeBDiev3aByZEKmTPaPc+5t69C2/KwyVyYE94qTR2F6yWvfWB3LGINNHeoc45bt6ige
	wpzWhuhX/o1Ob60V+p5+WC2/pv4nd+X1AtWQt6absuRNMfzCANJcT8U55nXzopy+jqFADdRjuro
	Ul+3UjCojG1Ee+3ANUFJh8yo2aYvJA9hMApHrXqe4qWfRGj8rszacGqsph7svyr+CMOyOVIGDXI
	nxVpYbF9oe3tISaer4xsVM4rSmcQl75gTYUswqPL648teGWeTNdSP+5YWgy5tZO9N6+mGsEqi7p
	nWwE2dBu8sB7WwPRdzupzqgRwoMIcwOk5h4miCLNwD9BWOgPXi1myY4dnJbQziYVZf5cv3erY0T
	/BG/ugZyxgBIYhU+G/VGxCKLBT/LMC6k6ZBuNqznlk5u881e7n9QL/Xi79jpT5hQyaQ==
X-Received: by 2002:a05:6a00:17a1:b0:82c:e0d7:2681 with SMTP id d2e1a72fcca58-82f8c8888b4mr16461966b3a.16.1776744954393;
        Mon, 20 Apr 2026 21:15:54 -0700 (PDT)
X-Received: by 2002:a05:6a00:17a1:b0:82c:e0d7:2681 with SMTP id d2e1a72fcca58-82f8c8888b4mr16461940b3a.16.1776744953857;
        Mon, 20 Apr 2026 21:15:53 -0700 (PDT)
Received: from hu-pkondeti-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebe68ebsm13484114b3a.47.2026.04.20.21.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 21:15:53 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:45:47 +0530
From: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
To: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
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
Message-ID: <8ad3fff0-578c-4db6-b3d8-00ce4e72e50b@quicinc.com>
References: <20260105154939.11041-1-will@kernel.org>
 <3f52367b-f927-4d4d-9df3-bcd8cd954d47@quicinc.com>
 <aeX5Q7QNxmBCmsqM@willie-the-truck>
 <573483a8-7cb7-479f-a96d-67416ef1f6db@quicinc.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <573483a8-7cb7-479f-a96d-67416ef1f6db@quicinc.com>
X-Proofpoint-ORIG-GUID: Roj2VHJ3uP1_jFtxcAxwryQGPqyUKcCT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDAzOSBTYWx0ZWRfX2h4umMHQba3f
 3q0sGgI9CK3WpqHaEyhJykwCuizvoReVBT4bPtn2eX8fYv1Av5NSRK28oi13ZcfarFkQp1okASb
 Q4mjxsu1DEmyWai+6b25Z5YPLgHn2bdH+CmjpHNa0qdaxAFARJS8Iw0lDVlFOr9NauFb+6SAsnA
 vVh8IIWjtTLZhcAQSAale6qQVd5O0+3J6xOb+WFy7jUQKud6sz9jg9/CjOK7Z3nqqCMriO85K5N
 MVwZADxveY1bJXe6+874XcZ6SkdC100OB7zc1U6+0ua/hIiU0HFL8CBerfx3RtnCOK3sLt9mQM0
 HaUU01e11ObGBOhjokbSCbOHQVlDflMzNan3Z10iNRXvnLNYXNQ6pxMlfgttFk1kuh72tIURfqm
 GTlkhyb2CS8nnrh3hYuduWoELlcxdD3cHOmZGEUgrEYvrkvrDIlwKy/VHaIKcHZEn+y7SLXTJeK
 tHwx6x9x0W2ih2okD8g==
X-Authority-Analysis: v=2.4 cv=XMoAjwhE c=1 sm=1 tr=0 ts=69e6f9fb cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=usknv1qGnw5aPmP1rO0A:9 a=CjuIK1q_8ugA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: Roj2VHJ3uP1_jFtxcAxwryQGPqyUKcCT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604210039

On Mon, Apr 20, 2026 at 04:56:57PM +0530, Pavan Kondeti wrote:
> On Mon, Apr 20, 2026 at 11:00:35AM +0100, Will Deacon wrote:
> > On Mon, Apr 20, 2026 at 01:32:03PM +0530, Pavan Kondeti wrote:
> > > Hi Will,
> > > 
> > > On Mon, Jan 05, 2026 at 03:49:08PM +0000, Will Deacon wrote:
> > > > Hi folks,
> > > > 
> > > > Although pKVM has been shipping in Android kernels for a while now,
> > > > protected guest (pVM) support has been somewhat languishing upstream.
> > > > This has partly been because we've been waiting for guest_memfd() but
> > > > also because it hasn't been clear how to expose pVMs to userspace (which
> > > > is necessary for testing) without getting everything in place beforehand.
> > > > This has led to frustration on both sides of the fence [1] and so this
> > > > patch series attempts to get things moving again by exposing pVM
> > > > features in an incremental fashion based on top of anonymous memory,
> > > > which is what we have been using in Android. The big difference between
> > > > this series and the Android implementation is the graceful handling of
> > > > host stage-2 faults arising from accesses made using kernel mappings.
> > > > The hope is that this will unblock pKVM upstreaming efforts while the
> > > > guest_memfd() work continues to evolve.
> > > > 
> > > > Specifically, this patch series implements support for protected guest
> > > > memory with pKVM, where pages are unmapped from the host as they are
> > > > faulted into the guest and can be shared back from the guest using pKVM
> > > > hypercalls. Protected guests are created using a new machine type
> > > > identifier and can be booted to a shell using the kvmtool patches
> > > > available at [2], which finally means that we are able to test the pVM
> > > > logic in pKVM. Since this is an incremental step towards full isolation
> > > > from the host (for example, the CPU register state and DMA accesses are
> > > > not yet isolated), creating a pVM requires a developer Kconfig option to
> > > > be enabled in addition to booting with 'kvm-arm.mode=protected' and
> > > > results in a kernel taint.
> > > > 
> > > 
> > > Good to see Protected VM support in upstream w/ pKVM.
> > > 
> > > We (Qualcomm) have been trying to resume Gunyah upstreaming [1] efforts 
> > > for some time but the path to re-use guest_memfd is not straight forward as
> > > guest_memfd is tightly coupled with KVM. While the efforts to use it for
> > > pKVM is pending and refactoring to make it use outside KVM is not
> > > happening anytime soon, we plan to send Gunyah series similar to how
> > > this series is dealt with pages lent/donated to the Guest. Please let us
> > > know if you have any suggestions/comments for us.
> > 
> > The major problem I see with this is that the host/hyp interface for
> > handling stage-2 faults is internal to pKVM. The exception is injected
> > back into the host using a funky ESR encoding and the hypercall used
> > to forcefully reclaim the page is not ABI. I have no appetite for
> > standardising these mechanisms (the flexibility is one of pKVM's big
> > advantages) but I also do not want to complicate EL1 fault handling path
> > with hypervisor-specific crap that we have to maintain forever.
> 
> Thanks Will for the feedback. Agree that we don't want to sprinkle Gunyah
> specific checks in fault handling code. Do we need to handle anything
> apart from
> 
> (a) user space access a memory that is lent to the guest. Gunyah will 
> inject Synchronous External Abort and the offending process will be killed.
> 
> (b) For kernel access, we need to unmap the memory at S1 while lending
> it to the guest. Earlier, Elliot attempted this with [1]. I am thinking
> we can leverage from Direct map removal work done for guest_memfd w/o
> really using it :-) . I am hoping [2] can be made available for Gunyah
> module as well.
> 
> For the (b) problem above, pKVM takes a different route in upstream i.e
> pkvm_force_reclaim_guest_page(). I believe this avoids kernel panic at 
> the expense of memory corruption in the guest. correct?

sorry, not memory corruption but returning -EFAULT to VCPU_RUN ioctl
which probably make VMM to kill the VM.

Thanks,
Pavan
