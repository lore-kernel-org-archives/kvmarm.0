Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C2851477A
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790117628; cv=none; b=J0ZIdEENdBq5bIcWv2hl91Kigz+Vi7gWuGySiThc+SQuXheVCzy5mXqyHXx2QO7i1eJb+ufjBD/pHC91Mzqa+CLMiOgRhk0uKgr1xJ425otK3ua5ZnWu8I2DMdLv+H9wDWPC5BaCuSl180YVnpVvQ436g+m5g26d0AvRgz/hgJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790117628; c=relaxed/simple;
	bh=343dUSnYOysjpy5fyuWntmT3fKeHN580Y5d1wxsBcrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ruAj5R9Uj3rpnCELUT0nhPcBpGpl+uYWLLjdidrcY5iHM/ed9pRsWm9rKzbB6gppTdptZP7hMU+ddrUG0kYvhkn6NMN6oYHVx/+F9gCG3PjDiMWGzz8r1qZeqXAJlx94zZ+cZaK8WWHk0saLUiKC/aJQLg1vOI1O20JGF0rXjoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T0jMB3y0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=C4udDO3A; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T0jMB3y0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="C4udDO3A"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MI6qmU178641
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ij3pQRHyLZbZtGm1WSsSpgH2KR2KK6oLa6dVIzgew98=; b=T0jMB3y0rL8j0v0n
	uLQ9L1ct+DF5ggyvqScz234nKNMbEy/2euOzbMqYlNwebz2EMqzizBoskOik5kaf
	5OJIIYXDaGGMxfc/PbxdMF/xa4eAmIHoSu9t2LwPE/BrNcUHf687+RrvoMq3mckU
	/ss+V85KBbnPpfroU9jjsSPT4EiBw2ScJSrw60JNNHk8Q5KBD3+Z74OtnL05CGbJ
	2BeU8SYiC6J0gBkULd3MqUx1qpkZmxmzDe2RreJezeE8IQmEu82IDQQkZ3jzRuJQ
	Y0efI4/JaTIRCIlDteaRp6xaaXgm7pLAJ+UrhwjYelKZ63sE2RpbOoQaT9CkoG7V
	Rz3sNQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guuec2fk2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:53:43 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-32850005b6bso351496eec.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790117623; x=1790722423; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ij3pQRHyLZbZtGm1WSsSpgH2KR2KK6oLa6dVIzgew98=;
        b=C4udDO3AR5kAVFVy2N/rxYxrwH0TYSasyIP/2P/pnh40So+b0duWoS8bHPXv5nVFaU
         fVuSnNUiQNwaJ+t90g3D9UHBZuGLglvM8Stl8U0WGr6bPSGLZ4qOIb9xTDcAlU3Z6xcj
         KYvctmUWDcwl/flKB7YjerVEZ501zQahiRfTTOdEl3SNH+tbukMdbyNHMHXInyPgMSjP
         Lr+LJiwDp2GuuwGHti8Lg4gkOPFvCLcD11QEw5pIy/NzGw+GEh1PkNYBnmx3tzSRzP1Q
         43U++ZV4D07dWxz+AWtaRN2TrAt1C4UhNUUvTvNX2b5tTw4YHcZPiZE5L48iOFsWhpa4
         Dx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790117623; x=1790722423;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ij3pQRHyLZbZtGm1WSsSpgH2KR2KK6oLa6dVIzgew98=;
        b=yYNCgkFpcahjbOT+Nzz6UEJLh6hkoKhgUYMxEMuc0h26zlHkzkVT5ES19GeOOQTbv7
         62csl2hy66sDJ7HNG8gSMqNJskc95WPab+u+eO6Uah17SpU08/eL1k8c4iU4/2sarJiT
         BHYMmVKCehPgDy5+nCGD1Hz8YLXTAy2kLSy2AjZuMMtaIRAdW5yZdu0hTY3FH/jse3E3
         LeNhKa25J0JC+BDhJtXB24kONq1l9I2OIrQQBe2s46tZut6U+eaLG4DzGoSCVvld5e6s
         dUEJLX0adaxo8+lwV+O0BecG19QsJe/kiARBOoKGvq6GXhkkWWsFhAWJMnsmrq9cVcZm
         s+Bw==
X-Forwarded-Encrypted: i=1; AKwUvBzD0sYYuyj/jdeIFEcQuRcpL3BliC90OIbvBekVPk5InBeLLdOwTh0wFWjWG3TclqgbhhLh+Gc=@lists.linux.dev
X-Gm-Message-State: AFuF++nIBKH0ImFqDTCQP+Krc5qg6KZBS4McRKbtuXCEVtBIIgPLvRDD
	BrtoRMm16RpymGbia/zhQCkSq/Uu5vdACtbpvTa/rnvFtsqjSUYZUCkuOEIzHFZvbuhfb9Ezp+K
	T0xsPJoJY2pBLlpfAjk2490b7SuLzp9oCsskJBv383UXx4dDEcR99gKHCiLE=
X-Gm-Gg: AYBFou1TAxjYzXsAFQnT+NJj1cbzy7OJ+RuDUCFx4yVOrDMJmBZOZm+NJNFXKPQvla7
	C2I0uvshxSk5fVOP3vQ/5tg3GkfVWPKgoTQJXBG+gPlCM23P5UXSbnJmBzADNc4JDD0yQLfkQ7+
	oRe7ydtgbwL/NG33q07w/fTkdu/PJkIo+V24E75amrVST8+pZH+09+LZyEcGJdjtGNYwmTiiTbx
	n90PgIteitp0jxLh0yQydEgN2RNnDJcmRn4wt0LOu/Af/qkwOWAINDS18g+lZLqVxkwQPQ6OibX
	jyK9JOsx6XS+TuTnHG+9nrfLdXSO7cTnqUFjzCKsDnns/ODxP46GfrN+gdDUxhg4blBl7JTQkG4
	xcaoWXJ1IFrhlTIxZkABtTlPTTytC6uklJY1ffPFzifSjLwN57iyl8A==
X-Received: by 2002:a05:693c:801c:b0:33b:ef1f:14b9 with SMTP id 5a478bee46e88-33e8c250524mr868842eec.15.1790117623118;
        Tue, 22 Sep 2026 15:53:43 -0700 (PDT)
X-Received: by 2002:a05:693c:801c:b0:33b:ef1f:14b9 with SMTP id 5a478bee46e88-33e8c250524mr868793eec.15.1790117622505;
        Tue, 22 Sep 2026 15:53:42 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96848e18sm1178819eec.17.2026.09.22.15.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:53:42 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:53:38 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
        aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
        joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
        linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
        sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
        WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v19 16/20] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Message-ID: <20260922155338.000064e5@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-17-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-17-suzuki.poulose@arm.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDMwMyBTYWx0ZWRfX78gEkrNDAzzj
 eHIEwJluTLgjRKecs4ysbGw2evtv/z3VRvQrraM7kF3wYMX6RmOXnOL+92BtgR/YAnDMnDKwg2Q
 XprAnNsn3WTa8Z/SFB5z3sMFJOOkjkabAZEbRkNJZzvrIDiMKJjH4/NXURP/t7RXR6v3L16AnT9
 6M94UnVrdbA+FdwmfnFBOFP6IUqb0GhR8LqN5HiFklAFC0NXRn2bGID20HK77dmAyg8w7s6D7qR
 p8NRkTwWPCXEOoYEiU2dgJok/zyB1C5iAM8V99S3JMFRnbyjDdHIrbmVBfcpjltmNGrTsSgx4Jz
 Qb5ySfWTi5jrXFGIVF8CmZLslv2HR5byCTG6w4WzMdma88THLd56mBz68X8jF8PhbdLlyR+ozgW
 imyO6MLl/KGtBwlUve4xTPqvCY+KH85UK/McAn4ddqmxjUnremlqG0e9qLq6yU23U8HCt4TvPS/
 ueyoYehBUQvcA4AKpNg==
X-Authority-Analysis: v=2.4 cv=VKdIDNPX c=1 sm=1 tr=0 ts=6ab306f7 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=7CQSdrXTAAAA:8 a=z_NLTHdx8yjNkCs6FmoA:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: rbFz94GeQdpzPd-QGNAxVB2yileb6Ahw
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDMwMyBTYWx0ZWRfXwD82MhWRGkk/
 qg9jBxn6mVlM/+5ZwT1bcGC766apU0qAVDQSkh+NqFXfvObMpjpnO5RBgKabVSDe7H/ab2+ATHV
 tGYZr5OQM8NrSm+aWYEgzM+4P43kqiM=
X-Proofpoint-ORIG-GUID: rbFz94GeQdpzPd-QGNAxVB2yileb6Ahw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220303

On Sun, 20 Sep 2026 22:28:41 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> Limit the capabilities that are allowed for Realm VMs. Similarly block
> the vm_ioctls backed by the capabilities.
> 
> Repurpose the kvm_pkvm_ioctl_allowed() to support both pKVM and Realm
> ioctls. Rename the helper to kvm_vm_ioctl_allowed() and move it
> into arch/arm64/kvm/arm.c. Also add a generic kvm_vm_ext_allowed()
> to handle pKVM and Realm capability filtering and route them accordingly.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
One trivial - otherwise seems fine to me.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 86e705330d7bd..eab8543a4194d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

> +/*
> + * Check whether the KVM VM IOCTL is allowed. For pKVM and Realm VMs, certain
> + * ioctls are not allowed. Further, certain features are allowed only for
> + * non-protected VMs in pKVM.
> + */
> +static inline bool kvm_vm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
> +{
> +	long ext;
> +	int r;
> +
> +	/*
> +	 * We are guaranteed to be called with a valid kvm instance, as the
> +	 * only caller is kvm_arch_vm_ioctl(). Catch any deviations, as we
> +	 * rely on the kvm instance below.
> +	 */
> +	if (WARN_ON_ONCE(!kvm))
> +		return false;
> +
> +	/* Cover both pKVM host and Realm VMs */

Comment is a little confusing.  This is the path that covers everything
other than those two.  Maybe 'Rest of function covers both...'

> +	if (!kvm_vm_hyp_is_distrusting(kvm))
> +		return true;
> +
> +	r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
> +	if (WARN_ON_ONCE(r < 0))
> +		return false;
> +
> +	return kvm_vm_ext_allowed(kvm, ext);
> +}
