Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2306514766
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790026151; cv=none; b=eIhTS/+mpDJpBNqPPClrczmTP1XVBpM2RboXTQV9G/qkPZjCTaa+3w5db4ohPrPtnssHe28KdZk6oFzxnCRI9r7n8CMusbOZ73uIM+HNjBOf8zDfyBT6hBl6Il5KExhCGWvl0t6S11KRdw7ickNuSkFrI/qhnt9kz1cad+RuA7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790026151; c=relaxed/simple;
	bh=gLY6HUm8Fgpr8Ezq0Rtau7ndFBb0bwJOlxu/UESTFNM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DozX8fQApWrwU5nAYF+M7kCeBTntoAVBYjB1Hoxin19YSgI+v28uwSwOWMTYP1HGU224K72kPMDmB9fxJLfWL0Ql+rMe4wx2RRNUZF9w0xHFUyIlpyOwPuzPVoRZ1SQcnQd5XtPXqn/9hQ2SlHq2CqM64Wb40Iio/sZFD0OIJD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GTU4lB+B; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NxEhr1Hd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GTU4lB+B";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NxEhr1Hd"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LKeKv52260398
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SfLBfPT4P8YTcQ8clLoZdz2Hz7ChZoOgs/WWhX6OuK8=; b=GTU4lB+BBWko+ahD
	WLILQlwA00dwI4xT3PrluEnAwoU5OMSwBVsgqduNQS8GI01xMCib9CJP2bobH+Oj
	mP84brkPaguPWG49c+1pPUh3ZQSCIdoutRYl+F8niVxgRgADPGHPmt5VNZQr/hEy
	igi/fx/Z/D8GV4qjysVMVj51djoxhHz59ku1okilekdfELtwWt7HLZ22TilBTAql
	xgMq9PlxwPCDJUHXuR1xPe94ZSlF1M0lHk73H2s1PneEI/YH8rgvc11LQ4fr4rN5
	DdOMqE1F5tes5sfkYOtHrV18t0XHWZjP43oExADCb8gkTHqzjQi1rZ5oNLUIWaF7
	bgm4SA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu8w78xv2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:29:08 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc73f47bdcso56570175ad.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790026147; x=1790630947; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SfLBfPT4P8YTcQ8clLoZdz2Hz7ChZoOgs/WWhX6OuK8=;
        b=NxEhr1Hdzk8LrI8mHC3OUfUPsBJ2fBxY6XDu6kg3PHoiONqu2uCqXKdllE5SLPXujL
         KG/+NO3NiLmBb3SWovLKw3VLRkE4ksLx0G3F6j03lUZbKTIFkNRAvC0LvCuI+5p7SZWs
         D9RJNczScMddYTM+SvqYk/aUSMmTALts9EcwemnBcOhmOcaxXfnpjpymxNtYJDIvQV8Z
         EY5OC21BPoSRbxC0/lGCQEsPtCq9d/OTdcuWAP/lLhb4PZKW4VlnmytP0TnOSAxbluoH
         q+bxZmGxN4SXXY6B+TD0KMLkAKGR7f3IVbtCdKuM40Aa4yY9lj0ZceQJuT3qpGgSkTna
         w+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790026147; x=1790630947;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SfLBfPT4P8YTcQ8clLoZdz2Hz7ChZoOgs/WWhX6OuK8=;
        b=OhCL9izJfVGh/rz25mBpBwU0xqcxAt4PIQsqEUTv/lKZb+b4viBDno6/Z9N2ur5u9v
         sXnTMWrIDzNqXGjslaa9qIH0ivPJo2T41DPD4TenN2zdcWGsVyd+9SVRlTWhT8y0bzM1
         gxzNvo9QFy4HnxcQKdQm2S6hLA826cCxW/bbV/4RrT6xKZ9uj/aKniLrERcVlRBxHxYi
         AaZgXitC6a/diMK2gbVJL8714f29K6sDak5sJfCaI5beDdGGoEGQ4vKhUnJ6wq3SPKKE
         Us96aooH6w0LNyVs5CxgXEDbXljZoBEnv6rNXYxiy3x6ZbLZWm1c89EDwsOMHrG3ojPc
         IJ+g==
X-Forwarded-Encrypted: i=1; AKwUvBxWU79VKkWM4qJz2B3cuJbKIZmuGg3Nxq9i+621yTWLeRfgpsfcxoZwAsbKJmW+Ef0bbVYZlVI=@lists.linux.dev
X-Gm-Message-State: AFuF++ndAknYFZaMXNbHdrWLmviGxP9xFmqectHgo0Rg5nSqBt0Ecx2v
	BAT9iarUzpIOdYq4sm69PC+XRfNopnuYQH7tHRAN8Hk8KvZvHccT/7Ac0mFZmwrXVY0cM3dvfwM
	FhC7GmVi80zG4tv3zx0XDFdzGLpYTSgFWrE8ZX4FdLMhgUC5lolOMz7yB2cA=
X-Gm-Gg: AYBFou26ZKc62H0Df0siUjYK6+e5KwWkpwzpGGosmVLLNnmGyrR0g8qxHRX5rzy+tlu
	sjN/EGRtR+0pWzF2P+xMGY/k/HwKUWBTYHB9h9jacHgfxs4pwSkDkOXuYqOxL9x2ok1WoPv4PVw
	beg/h5Xr10qnS8PhBQfKewMAcwTNCjQunGV+xvaSVfLa46ZLhqV2TL3homWFVEp1iH+FoPMmpLl
	aexOo/XmhH2QeFGFfKClVYe5NRMegPM/atwESCwxIJSTUUU9R/Gio16zYTfjkxuzBs7NX1vVU8Z
	ifoRPOc4VyVnCykLuu6xtVG9+nTm/izgEPpHpsSN4b9Sfgjh7wN3H04NdhXmCM50lbw5O1zSxVh
	p4g+zGMAE3nXAVGQKvMP9m7OhGg==
X-Received: by 2002:a17:902:e745:b0:2dd:ad73:c98d with SMTP id d9443c01a7336-2ddb1bdefcdmr158852115ad.37.1790026147198;
        Mon, 21 Sep 2026 14:29:07 -0700 (PDT)
X-Received: by 2002:a17:902:e745:b0:2dd:ad73:c98d with SMTP id d9443c01a7336-2ddb1bdefcdmr158851845ad.37.1790026146755;
        Mon, 21 Sep 2026 14:29:06 -0700 (PDT)
Received: from localhost ([50.35.44.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e5eabe1b9sm780432eec.2.2026.09.21.14.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:29:06 -0700 (PDT)
Date: Mon, 21 Sep 2026 14:29:03 -0700
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
Subject: Re: [PATCH v18 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
Message-ID: <20260921142903.000071d7@oss.qualcomm.com>
In-Reply-To: <eb4a30a0-abd2-4334-b5f3-62621ec5a19e@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
	<20260912083611.2513845-2-suzuki.poulose@arm.com>
	<178978126540.2352296.16845657485139032765.b4-review@b4>
	<d7ccaf22-5bde-4344-8bf0-a5a17dcac0f3@arm.com>
	<eb4a30a0-abd2-4334-b5f3-62621ec5a19e@arm.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: qRkKT5WA10x9VRQJMNF6DqPxjkMmIQtA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDMxNCBTYWx0ZWRfX+g3JnnAZy/7f
 M8dvQhblVptCL5Vi10DycQQj4awdZd7HcrySNw1MrYZUxqATc9pcSw03AHCG78V8MJJ116fPCeH
 oGxA83xyNhRRxiJxOM+Vpehz8f5Gu8egtScAoID3lrpRv6HcHZLGAC0pvdk3LrbtIHWKxuHav3c
 1uIYsskRmO8H6+kZqhfeGRnqvQOWwm7oBa4QXHzFY7+u3tkJYSv/FxX6B6UNQH7Smzgk3EnBNHN
 NNfoeS2+ou+mcwo70LyVLUnbV2TGMeiqj2W4UiR6ChvjH7qzlVjVie0Zktrgs9DgGl04mNmPfOZ
 e5nPPukBdGKvLSmLnc1Z02X1Wr+7AFazgKRLMoPdPt8ry0rEEZzjkbBEaHRfkJKTrhOzZopwehT
 o6wLiitqKycsImzn6bCyN3qQGUJA5SPz47uvrAvWPEB8AnfHidYx7MJbwqKHE2K4B/ZntH4/Yxr
 SP+WDPKD00dBlK5p5Ow==
X-Proofpoint-ORIG-GUID: qRkKT5WA10x9VRQJMNF6DqPxjkMmIQtA
X-Authority-Analysis: v=2.4 cv=Vqi2kO2n c=1 sm=1 tr=0 ts=6ab1a1a4 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=aNnz9XPx1a4JIXSYt2cE/A==:17
 a=8nJEP1OIZ-IA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=7CQSdrXTAAAA:8 a=ZpRu-6ZVBUCh-PS3OmgA:9 a=wPNLvfGTeEIA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDMxNCBTYWx0ZWRfXz1o5xpm5/HGe
 NI6J4L/vPVWZFtF7b+8AyBIazzO2DuxAAuWi/46LCLN7mBwYJFQpq7x6qbaQ6P2iBRTIVVx3k02
 aYySxbUgW3VwGwDhJiOQqQwJ535bJnA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210314

On Mon, 21 Sep 2026 11:14:22 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> On 21/09/2026 10:27, Suzuki K Poulose wrote:
> > On 19/09/2026 02:27, Jonathan Cameron wrote: =20
> >>> The RMM (Realm Management Monitor) provides functionality that can be
> >>> accessed by SMC calls from the host.
> >>>
> >>> The SMC definitions are based on DEN0137[1] version 2.0-bet3
> >>>
> >>> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
> >>>
> >>> Signed-off-by: Steven Price <steven.price@arm.com>
> >>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com> =20
> >>
> >> With Gavin's nitpicks and the GENMASK_ULL() from sashiko, just a few
> >> comments inline.=A0 Mostly on subtle inconsistencies that really don't
> >> matter that much.
> >> =20
> >>> =A0 include/linux/arm-smccc-rmi.h | 497 +++++++++++++++++++++++++++++=
+++++
> >>> =A0 1 file changed, 497 insertions(+)
> >>> =A0 create mode 100644 include/linux/arm-smccc-rmi.h
> >>>
> >>> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-=
=20
> >>> rmi.h
> >>> new file mode 100644
> >>> index 000000000000..214d6228dfc2
> >>> --- /dev/null
> >>> +++ b/include/linux/arm-smccc-rmi.h =20
>=20
> ..
>=20
> >>> +
> >>> +struct rec_exit {
> >>> +=A0=A0=A0 union { /* 0x000 */
> >>> +=A0=A0=A0=A0=A0=A0=A0 u8 exit_reason;
> >>> +=A0=A0=A0=A0=A0=A0=A0 u8 padding0[0x100]; =20
>=20
> ...
>=20
> >> =20
> >>> +=A0=A0=A0 };
> >>> +=A0=A0=A0 union { /* 0x400 */
> >>> +=A0=A0=A0=A0=A0=A0=A0 struct {
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 cntp_ctl;
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 cntp_cval;
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 cntv_ctl;
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 cntv_cval;
> >>> +=A0=A0=A0=A0=A0=A0=A0 };
> >>> +=A0=A0=A0=A0=A0=A0=A0 u8 padding4[0x100];
> >>> +=A0=A0=A0 };
> >>> +=A0=A0=A0 union { /* 0x500 */
> >>> +=A0=A0=A0=A0=A0=A0=A0 struct {
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 ripas_base;
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 ripas_top;
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 ripas_value;
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 padding5[0xf]; =20
> >>
> >> In various other places you just use a u64 for a u8
> >> + padding. Why is this one special? And for that matter
> >> various other fields later in this particular structure? =20
> >=20
> > Please feel free to point out, if you spot any. I am happy
> > to fix them. =20
>=20
> I took a look and the padding is for extra "u64" bits in there.
> e.g, ripas_value offset =3D 0x510 and the s2ap_base is really at 0x520
> not 0x518. Same applies for the pmu_ovf_status and vsmmu.
>=20
> So, I would leave them as they are. The rest are consistent.
> e.g, num_bps and num_wps. in realm_parameter
Ok. That's logical enough for me.  When no padding happens to follow
that goes beyond the u64 then use that for simplicity and if there
is padding anyway use a u8[] that include the rest of the u64 and
the next bit

Thanks for talking me through it!

Jonathan
>=20
> Cheers
> Suzuki
>=20
>=20
> > =20

