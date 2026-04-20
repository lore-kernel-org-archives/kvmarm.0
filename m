Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906733822B2
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 08:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776672133; cv=none; b=MGmC6oHBQOapQDBIaSq4xFzDR/rgHWhRTyCIlY3scPnTF/Mg1eZ6KxpIsn+VfVmJIc9gMHAckWAwaX3NINdI72RupZelq804CYKq2RBf08d45jIte5Cnsf749+jO4pJv7z8rS5oEiTYy1I7ljdwkTAnXDIv6/jp9dZwp4jnDcqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776672133; c=relaxed/simple;
	bh=RW1F86MU6O9yNj19KU4OYvPa4ICaihO11zaBkGDcWps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P8gXjzxCVRgNbHnDFKsQ3nGYFbuLiXGbMzsSrGEXSoBtutueqXNcOymVeG9GSaAAZA/O3Dqdlmxzq7+0GRYG4ox/ZwVQQS7f6x5oOagZvxNIjcXCdTOUhTv1Uz/w1Cz09o93lsVCh+W3dKUOYW1euC5SEolNFVnUqxa8h6ygdJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GfOL26Uh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=awcJ6gud; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GfOL26Uh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="awcJ6gud"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K7W9051475377
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 08:02:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=uyLNVnLhvqgP/9eazyTAksD1
	yYCngDRJ5jtR0ZQJ7/0=; b=GfOL26UhQ9dennEiHyv4FygYiyKhAvUMGKDJweSC
	Vb4OXYfjbXAtzEDt8Uf7cjB8Cqb9YaWzBDuuzDH4ao8NxRdsoIk3NeURRTaKMng/
	EtIWI6AUT2pkJ1douRR4oH6L6MnXD6byDJKu/nSRsdD5fb4f821tuRhEu4PjUjgl
	BwYn/BeYwFOjsCqaoNgWVgzipM+zcTJeWgHwTr5pujhlJXmuUTIA/Ec+t6dakRo4
	FAcsaBUUiPjVJy6WffKcfZ07HdFGvPKKrxoXeorabDjUq7/Ql5i1wR7nGUOhjM2s
	nF0cJNjpcGp/bBs8D/k4prte6HjFYgE+3nNsyy2pQJmL1A==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dm0wr50dm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 08:02:11 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b2d83e7461so46071165ad.3
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 01:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776672131; x=1777276931; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uyLNVnLhvqgP/9eazyTAksD1yYCngDRJ5jtR0ZQJ7/0=;
        b=awcJ6gudQW6uI1/27gZtqR5eCnH15iXscXtgATwyC0SxOKrhu+iOvptsvqYRIRFNrR
         37DBMFH3F8psCaW2FYAUxmyI3kUk2L7nv2ITH8iOCUo4exbFyAXC3x0CN1WfqJ26wu4+
         TXLBDaMyK0qhIJwCdyQa8Rm3ioiNsYOGiSUH+kTcemTXLwl4YKCKJ1B8kdCup5z7E2tP
         lG1djyxmt87DtgBOacwtuYSTpsWfrsaVAKWrm9uIuQvn2FMEeBNiVioOCnm6rMnOJvA6
         H/QI8a29C2xc1xxzf2HWGTcMWwjwi+caGNM0dsMtJIn1kd9382h/1+tf4Hc01hFaXa/F
         SqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776672131; x=1777276931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uyLNVnLhvqgP/9eazyTAksD1yYCngDRJ5jtR0ZQJ7/0=;
        b=bt4wVl7QSd3dJvqr4whfumiml1EuX3Vpg2PdZVBNNvpDGrpeAcLN7xY2f7Ev7BPvZJ
         k0oH+a46LpS5KsNQ127p+xYfLUemEghQ8DxiK+0V9zvUq0nD/y6eHIBv7ekekHDkdl1J
         HSb+sZe2XMqu+rU/y9iTqJYEuCJQgSU52rqVaKX1RyYo4Gq+XAgt85JjhfUcYFcf/sX2
         NaWAceEhB1805pwCbe8W5AlNtMGgoXV6v54oHrmo5EvwXRqRt8KyLntaAB8MDCyHkkMb
         7qexy6AamCjNECYyFiJxFLlNyuM5cD4IpVEMIVRg1Ji5DiGExsEsmWWetKgrx92GHX5k
         IfhQ==
X-Gm-Message-State: AOJu0Yx/2OW6my9rkdcQjUmt2vhfOvxRMZ5VMrF/ihYkxmPQ4hE+aIX7
	HFJdyTDUEhbsvQ3rdgXja11M1K4L7H8eqMwErlvC5QaLSEsiFhJMZYOlGaLNMjgg74tR3IA1brq
	pWhEDjNZHDMFinczyWupPqFB5TutEYaDNirogw/F6CgBu6L3dhKMHDkoea0pEJigtcOU=
X-Gm-Gg: AeBDieuZlQtBsGzftxO7zuzgotHFm5ZVefqMkzKSB4ljh6dxetVOjCXEQt1xXfk25aC
	2e5mqGWkf0j4HvJpsdI1OoVSWjoWWhCd+L0H5xIgt+qs/EoK5Pq5v/O9lzEtD9LzyLgA4lOJmBM
	w/VuFy4xKpOgVso3akbWTZTALo6nIUQi2Q+YEmiTxACovORRbZn5kQ+PTW/FBAwyb0Ks9DV1VNt
	TLyYsAFKtQhnpDEj1b+2cui2Hr5oZ3AuOk0jiIppel+B9+okn8qArDtNecXIhUPzYqy3nqdLZty
	qzUVROA5JF/ZeiPddS55p1H6mQx4R5DBlf2bZ3dMR2XksLjbUnZvN9ilIr4C6wf+uDot3iWDwNX
	r8onMiuDAY4hqNNYTEp8I6VjP5yqiDl4DGQpCVZdrrwq6wdlB0qHoNl6Y/zCOKJ8BBQ==
X-Received: by 2002:a05:6a20:158b:b0:398:7b18:837b with SMTP id adf61e73a8af0-3a08d78d8dbmr13014570637.25.1776672130798;
        Mon, 20 Apr 2026 01:02:10 -0700 (PDT)
X-Received: by 2002:a05:6a20:158b:b0:398:7b18:837b with SMTP id adf61e73a8af0-3a08d78d8dbmr13014506637.25.1776672130164;
        Mon, 20 Apr 2026 01:02:10 -0700 (PDT)
Received: from hu-pkondeti-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f8fcbdsm7098332a12.6.2026.04.20.01.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 01:02:09 -0700 (PDT)
Date: Mon, 20 Apr 2026 13:32:03 +0530
From: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 00/30] KVM: arm64: Add support for protected guest memory
 with pKVM
Message-ID: <3f52367b-f927-4d4d-9df3-bcd8cd954d47@quicinc.com>
References: <20260105154939.11041-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA3NyBTYWx0ZWRfX7ISmHcfp93II
 zM0VL50AmKDawnK7xSqY5+VJVDtLNeksDd1VSWMJpen/miPc/6D5ccd30wcABPp1dweDn1224dG
 K8FSJfoalUxAVsOgPCCvyX1Rrhc1id5I7520VBo4vefDY6bOKV0qkKycI1AqfZP4eh4IW9c6CF8
 xB0P23tjMKst35xOcQ7RyYOrIYgw3TRUChprJAmoBIwvMdJI5NFJNkKFCp5WTLP8WJw+bKoe0ED
 WSx2FZ06H4/wjqJVPZVP3V7opdhT2EWTbADKgtvpUsc01iWPrgNurTq1jK+fv69nUfQ8kDK5pQz
 Edve5uB1tv/6/Ja88KZWjoBNzPNDcW8g4xS+UyDiklU4WfH3Egs72ojMAUNhFt6AX+QyPqFV1CJ
 sXmu8sLOdCLZhkH4z3UytvZDacGC9Aao4jvy/ITWukXRYXAqo7s3ZLWHvXQTJoTXp67iYbX2LRl
 SclgsU86OWJil4zRt7Q==
X-Authority-Analysis: v=2.4 cv=G9Ys1dk5 c=1 sm=1 tr=0 ts=69e5dd83 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=s4NR7P1BVOtW2zOh99MA:9 a=CjuIK1q_8ugA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: 5Tu9ZnJnTgTXR0ECzVShVGESVHh5g1GO
X-Proofpoint-GUID: 5Tu9ZnJnTgTXR0ECzVShVGESVHh5g1GO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 adultscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200077

Hi Will,

On Mon, Jan 05, 2026 at 03:49:08PM +0000, Will Deacon wrote:
> Hi folks,
> 
> Although pKVM has been shipping in Android kernels for a while now,
> protected guest (pVM) support has been somewhat languishing upstream.
> This has partly been because we've been waiting for guest_memfd() but
> also because it hasn't been clear how to expose pVMs to userspace (which
> is necessary for testing) without getting everything in place beforehand.
> This has led to frustration on both sides of the fence [1] and so this
> patch series attempts to get things moving again by exposing pVM
> features in an incremental fashion based on top of anonymous memory,
> which is what we have been using in Android. The big difference between
> this series and the Android implementation is the graceful handling of
> host stage-2 faults arising from accesses made using kernel mappings.
> The hope is that this will unblock pKVM upstreaming efforts while the
> guest_memfd() work continues to evolve.
> 
> Specifically, this patch series implements support for protected guest
> memory with pKVM, where pages are unmapped from the host as they are
> faulted into the guest and can be shared back from the guest using pKVM
> hypercalls. Protected guests are created using a new machine type
> identifier and can be booted to a shell using the kvmtool patches
> available at [2], which finally means that we are able to test the pVM
> logic in pKVM. Since this is an incremental step towards full isolation
> from the host (for example, the CPU register state and DMA accesses are
> not yet isolated), creating a pVM requires a developer Kconfig option to
> be enabled in addition to booting with 'kvm-arm.mode=protected' and
> results in a kernel taint.
> 

Good to see Protected VM support in upstream w/ pKVM.

We (Qualcomm) have been trying to resume Gunyah upstreaming [1] efforts 
for some time but the path to re-use guest_memfd is not straight forward as
guest_memfd is tightly coupled with KVM. While the efforts to use it for
pKVM is pending and refactoring to make it use outside KVM is not
happening anytime soon, we plan to send Gunyah series similar to how
this series is dealt with pages lent/donated to the Guest. Please let us
know if you have any suggestions/comments for us.

[1]
https://lore.kernel.org/all/20240222-gunyah-v17-0-1e9da6763d38@quicinc.com/
Thanks,
Pavan
