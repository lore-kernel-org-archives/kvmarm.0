Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9A47ECEE
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790117383; cv=none; b=XRvtsRQz8OPfpVT54VJpVotqnVDg3qrcvxeBRwEvQNlvAl9Zlus9FCB2lNRB9RM1PYdjSESrL1SXsG4qYsWPJCMveUmPPjxT9WEvt+eNjGH4GMTXg5QBAixWhWJmC4hB1dXdPho/+jfdVRLCI/P6uIAXZBOoHgpZ5WmqM/LiGsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790117383; c=relaxed/simple;
	bh=qNzbdmq/oIh1lUZzfllq5i//OOvif/27x56ElsknR7A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UTNRy4waeYqkiVfz7Iapnsz1qwj0tA/XMb0jZ4CQqgAo8XYImge+2ac3uURzu4S4XjG87HXp2lbVmOkhmneFLfBPNOQvyk74X8OC9cbsQIlviU1MszMnpXsooX1T4lJCOrxMvYDmSXlbfJaPYl3Wa4sVdaG8BDTTkisnUoGWcLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f7DvbwpJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KjCHSz2B; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f7DvbwpJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KjCHSz2B"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MJCxoT1166713
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YorCO9U54gBbhM07YPBvezJSmHCc/9vnYs1YoAkAYVM=; b=f7DvbwpJMVDR7TMA
	P4ihPwzr1H6UYxQAMTawgCVJKNVtvcx4mE/9wflDq6mZ0GzO12c1imrLERwRAkl0
	nncQI5NA2EGyXi+9w1GA5++uYr04LbF5p+Ei/e8yy41f9Blz/+Dk0fDN45qgW6/f
	fTTbV5ePWcBvcJrC23PtMtbinCFVQvsg0JEl6VxcngSydKegP51NJG8iEOEcBlc/
	w5XpibGZsyfPemv/2izCojD9X6Zy802NjSVqZGkuJuiT78BcSIgtN2yz2UvN1X9T
	dJfdZ5+yDZS8CMMGUza5KrTYsutWQFYdXn74/ZdNRWbJXyDYyRKZ7xjTtIWufkUT
	QN/Cpw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guymw0y2n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:49:37 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33bb08e80a8so281014eec.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790117377; x=1790722177; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=YorCO9U54gBbhM07YPBvezJSmHCc/9vnYs1YoAkAYVM=;
        b=KjCHSz2B2aqgJ6vCEW23CCFHHELQnndQreTipXN/9eh66YA/RM4PzQFfyYZpcr4Fw4
         RT0uHaCB59Td2FhFYsnZc1mE9bgltXLEEieMRxBu9Ki3C84MTgJep5Jw2kIr1cOzk1sL
         89lWxBbtqn2i7Cqb062MZSrY4QmX5V38KpKU890qyJMM2nBQJ70pszt9rEEV+Ct9eynx
         VoUpCgEgO8JyPuhLFgyp0r8vymYJTCsDQU/Lltb0azdI8vxVJIfCBqtFRtAFWAqQmpyv
         Up9s2rFd4vI1BnOML6iKI6iEABkSTn5zYudBYaurUYc8IFxyVoOuaVXsTBjeTpM+/qq8
         Sl8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790117377; x=1790722177;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YorCO9U54gBbhM07YPBvezJSmHCc/9vnYs1YoAkAYVM=;
        b=sDYDPmPEC32+jaKaB3co1VZRg8CPK2pq0oJG64cQ0YuDQfYTiyYyBqgaXoGDLxx+sA
         AXz09uqDfvis8vODTMDzmHCDj4eg7kqAo20stGxtcEBFZq5u2fnTBblU6gf82yWMx6KP
         fhv9BGuf2g1KW2XpsFO2Yiq9DOLAyRQ86EH91pq1AmYqlFlMybmB+hlwhMyf0OqJMWY9
         03mah8Y44IKauXEp4W279yvTeChxdjWGHNYtZo98+tTKO1F5vQcHf/94i9g8lZPbOJtk
         TuIR4wkcWpn17mXie/V/iKd04JzbtRe1GkVwooKdjb9whS6LexrftFDUns06stBf2ITG
         /1Ug==
X-Forwarded-Encrypted: i=1; AKwUvBwhzkt9KsNh6Unnz5+u+yAcQta7fyMKG/rdi3Hir6V4i8F0vZfuXIxAheEX4aIiRofLV8wH4LI=@lists.linux.dev
X-Gm-Message-State: AFuF++lJf3YMPGq1avXkGHfNz4QVHOSN2XUyXI4uopryemG/3KIpLDbB
	KdHH+FU6/gG+Hw/p8b4D/C7641MWzJ9wslYPPlv6/Zg4v9YlTcAzazrf2Nf9nZZ5hJsy595VBo5
	H0aYAA1DJXwvIlmanzhbPEX+bo0Xf/t+RX9g8ghU88eJLYZPJmhsHVVeAlXc=
X-Gm-Gg: AYBFou0bsX+GeRv+9XIenFZ6j9Ubv2FMBnxvY+kiSb91l1bfV6cBr83ho6x1lmpi9C/
	6w5VNLc2uJx8My74bZdsyghml0/4A/mSNtKMdKUCf1VUTloBLvWXjK0GAtELPFLYQf41IvIVqwm
	BuJg/ahF4ZIEIxk6J0gf0tkBi4Pm3v2cye7GYL/rJvspGohFBQswG3j4JTOV8lvVqw9JocVetD/
	JM89UTK+WsniUlWoB3ndmji3qKQHZvG1g2HJOneVlR4HFMJ1L9tO7MvjCVAShg4HvDzOM4Ey9s4
	5CDESkJhpcX44yXJ4BMy3L5J+aJE5QfxZxKJbZjKBRpqe9lJUjwbdojRNGHTXHOP2lYvbfmE/Uu
	+q3WNeLYApL/47R7IOP5cK5NLnQqjYvaFOQqIAcw+X0D8d0ownjr7Kuw=
X-Received: by 2002:a05:7300:7a8d:b0:33c:1941:8f8e with SMTP id 5a478bee46e88-33e5ca9fdc9mr916120eec.13.1790117377261;
        Tue, 22 Sep 2026 15:49:37 -0700 (PDT)
X-Received: by 2002:a05:7300:7a8d:b0:33c:1941:8f8e with SMTP id 5a478bee46e88-33e5ca9fdc9mr916091eec.13.1790117376769;
        Tue, 22 Sep 2026 15:49:36 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e939fe502sm1214322eec.2.2026.09.22.15.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:49:36 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:49:31 -0700
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
Subject: Re: [PATCH v19 15/20] KVM: arm64: CCA: Introduce Realms
Message-ID: <20260922154931.0000171a@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-16-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-16-suzuki.poulose@arm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDMwMyBTYWx0ZWRfXxee+QXqFcfcj
 0JPxs//9wtabFssba9r4RMVg18cU/YiKWlaVlFsvFk0al1V9l+ng6aNHHsHKjFO73qfE1G/I3o1
 X141ibsbaXbFmcJTBIU2kYX4oqva3ttfkaI8UpJTyQuhnpVxe+iilB9G7jMNLWpsaw9GNyjJ8aK
 VaKzKhsfmPkSU7E4Fo7TV9Y+c6qsjXPjN7kzi0+OOlN03l5XA+M20YpXYqYivZz79Voe5jpCvj2
 KPMzjNK1tGiM8g15X9YB49XCKObU2ijCB+xxQ2dRabEtMNeHDJ79aWTBpOaOxzBd99CynFlrPoj
 kVO636q8TVvstZStM245XzPQkNHnbYiUQhNJk6/G+yuq0vUQvQwhiJx3Qj9ZyqmJQEDV9e5S0ZV
 GF2HCp46+HzF7r4apP/D3fqIzE2MTUjb2o8eTTpobGYVN8AkkSdCCZ0VQ0m6egKkhLQrbze0m/Z
 lzMZ+ZCWXWc6N8Eq6Cg==
X-Authority-Analysis: v=2.4 cv=feI4WEQF c=1 sm=1 tr=0 ts=6ab30601 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=1xClAnr3vSIPrHROFcAA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: ywLkvP-0nzysQOBrVkfSLCWWx8rOvyif
X-Proofpoint-ORIG-GUID: ywLkvP-0nzysQOBrVkfSLCWWx8rOvyif
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDMwMyBTYWx0ZWRfX15NuY6N9HX+5
 g9eGPspr035aiDRT/dDuf6pUv01alNN8DQ+CS6Bk6hUl+LhLCAvmHUC2mJE6wuqpa3cUJtXhYHV
 7Q1jMJiRxhK8X7qPXoYK85n+eYQaIxQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220303

On Sun, 20 Sep 2026 22:28:40 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> From: Steven Price <steven.price@arm.com>
> 
> Add foundational work for supporting Realms.
>  - Add a new VM flavor.
>  - At KVM init, check if the KVM can support Realms (though not functional yet)
>    and will be advertised by static key kvm_rmi_is_available. This will be
>    turned on in a later patches, once we have all the bits and pieces ready.
>    For now check if we are blessed with KVM_MODE_RMM.
>  - Add realm specific tracking in kvm_arch. Since Realm and protected pKVM
>    states are mutually exclusive, move them into a union.
> 
> Please note that we cannot create Realm VMs yet. This requires further changes
> to the UABI and core RMI driver support, which will come later.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Seems like sensible infrastructure to me.
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

