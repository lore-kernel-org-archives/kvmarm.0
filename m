Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AE639CD0A
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182296; cv=none; b=uGp9POPy3BJ9gyGNnnnIe3wVgEct3zGE/Wp56l19YwThrSPTjsnI39+eD6v0axXuvCuAj5pvP3WALbKk2KiNuaZASwgS9BbWUG5I+quaaJPKwI9f04KYSIICygwMpoAWDUhL07wQuRE1UD9RRj3iXgXL1UJmMp8dxSMKAYKbL8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182296; c=relaxed/simple;
	bh=5uQE2nAN6JX8QjSvUav79qHnjIuloRrBM4/qaaznXm0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Okphi42uZv0ah+cibANyk8niKXhOW5eG/8MWQ6VuIZReGdVDdpjWfOQaoXFEl4ALw24hmTzC3NiJeKIhc4X6ypaUaII8UYK4JQNN7c+sSYWCqjVYzGHVOeU5wlBFh+TzAZ3il87AiOCq/1tQdyKJqPOD19RHwNrm2RkBImneK1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i9oRYKy3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K5t/tbLX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i9oRYKy3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K5t/tbLX"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NGUGn43281284
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PBQUzucMPHhE43vcKCEgSbYL6NQCAu/bzyKeHz+O5EA=; b=i9oRYKy3vL47wL3Z
	TQiRtvSmmPuInfzryvrI89KQN+dcSf+ocCQvznV+sZqK2iSvtcq7BXyS401jaGhT
	zcGov9ln9gi/I7/ZYoQ/0o8keNSHp6Urwj3f6RXjyJYxmyCUBVijSDP0+K5VDMNq
	rzDkITKd+6gVSxn5bpeWejr6OUPWFfTzlpnq9t4fxXp6UZuty8fwK9UrEXehmIZb
	XUbz5eza6OybsyPp9UvlDbrkxWrQ194e83mOMXXPU0lmFAgm0qGatu1o/9U3yyLm
	U++9FQu8kXv4higPKiI06eI6bFqf5wPHXQab6mqq91q/D4mDzOCDArwOW5GhxxVV
	4IfuUw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gv9bqjqdy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:51:33 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-86a74698972so963709b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 09:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790182293; x=1790787093; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PBQUzucMPHhE43vcKCEgSbYL6NQCAu/bzyKeHz+O5EA=;
        b=K5t/tbLXLkuJ2ZMQEYNqNa+NsHPrmVKnFurMgvQ9v8xbx2gpYmFf9YFxyhwowzE7ov
         dhHkCboZ08SaQNZ9SVq9fpRhk+c5c/iwkGB873w2+bRNBcyyt4SGgmoKdx+F/hyVkhMv
         8zkDk3+mHNTjFFKEAbWor8sOcHdPMDmKWDBGg2oxyJkdlbbLiSaqCCatxJ4I5LSOcK5Q
         rssah4IRV9W1J5kTr5NrGQzNnT5R0B9Cuv6D4uRxIoqzH7UqZcrU9MVEbJd2xuD+Rrjj
         /RoyhespNARqBD2k0JCPOUeT/AucPxRvbe5tkWPMJidO0J2oqMqhPwUUXa7mJ/Evefv0
         14+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790182293; x=1790787093;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PBQUzucMPHhE43vcKCEgSbYL6NQCAu/bzyKeHz+O5EA=;
        b=M1I0wd0DhlRKDFHVxlnnYulTG+Y9tbTA2qiqIpW7hLnkWeKPKGk0MijV03H4smAT0D
         1s9zW/nPvqAIQyVl3Ki0yPdzYrgA0HYhIZDazWvsJIiSjmHqgKLE+2VETcJTYZKEvYpa
         MfW6piFtIASfLwORzRU+8TSoLmhuc2Lk+D/5FQ9s0/wHoB/mNar9dZ0PEFyNczu2aHIB
         k4+lN0HGOJ9rqm07gTIdehBOCGtpK2wlQrazjeVp9l/NX5ZL47ptogXIcdr4bDpvRGZD
         vc4eSJsqBtl35auzUpA04QAu1ZVJsXVCE4FV5q/T0l3V3qkBiSJlArxmSzYLCoSRLqjK
         G7lQ==
X-Forwarded-Encrypted: i=1; AKwUvBwMd/6xe/JT2rrJRndBKrnuSmb7iwjT4cqoE9NzJwfA3zgVJUBf9W6k+OJOdtTemDChGQqU+fU=@lists.linux.dev
X-Gm-Message-State: AFuF++nhMhi9DgYlyfABvro2mBlY/njEEUiar4GFMiRP1Z1/W4dpQnb2
	QbQQllr4vBAUGwbtF+kiZiGMo+KkUbkcfDx/qwPqTmZ2M1GLlXAKE42cuQM+R5nHweA9nxq7rae
	LUfnjR4v/0Cij72qRvoTLjibFHbRN8176+7SdzwlYXx7w5wTMrOoml8MdF6k=
X-Gm-Gg: AYBFou1yBg6CTLPZh/cdUtLvF2xDim8KSQhI4cTGXEDbnlREBIurwKV4O5UZHVHh46L
	5l5QJeE/ZB/rp8fHZ27s0yxZXwVP3rpNazScp7ZnBOFGxH+7fckQHnesbmhTHmtF6cX8rLvkEYx
	svIR3y2kJBNcrA7EWXTAkW7l/hll4fT9WX8n+AI6l3Co8+i9zYR6uT+LKiN3Bg5u73oiKzo+CiP
	T6pLo5RFuRUWSLS4hbIZEvzEQtjvyKAmbJcDwQy9ymNcuG7wmcTMsTKMBXnlviI1iHXn/TcJkkU
	T1SjZBUeLXrx3g7gErnbUL25TMdYwmMEV0lF+Cfe/Tw8+d8i+rTpre+AjcSPxZ5Yzna/Stz5DPk
	2N9fVxEST09k7th2NWD0J5ckcgWhEoIMDmEaSy+weTGGfBK4RTFBp1g==
X-Received: by 2002:a05:6a00:3316:b0:874:705d:f648 with SMTP id d2e1a72fcca58-87d1c9ba6femr2832640b3a.42.1790182293058;
        Wed, 23 Sep 2026 09:51:33 -0700 (PDT)
X-Received: by 2002:a05:6a00:3316:b0:874:705d:f648 with SMTP id d2e1a72fcca58-87d1c9ba6femr2832601b3a.42.1790182292399;
        Wed, 23 Sep 2026 09:51:32 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1cfbbfb5sm1725238b3a.18.2026.09.23.09.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 09:51:31 -0700 (PDT)
Date: Wed, 23 Sep 2026 09:51:26 -0700
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
Subject: Re: [PATCH v19 01/20] KVM: arm64: protected VM: Handle user writes
 to CNTVCT_EL0/CNTPCT_EL0
Message-ID: <20260923095126.0000241d@oss.qualcomm.com>
In-Reply-To: <fa2f4766-0795-464a-80ca-2f3fd1c5140b@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-2-suzuki.poulose@arm.com>
	<20260922122542.00006868@oss.qualcomm.com>
	<fa2f4766-0795-464a-80ca-2f3fd1c5140b@arm.com>
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
X-Proofpoint-GUID: c7Vak2k3nd_Y44XXXJ-98GDHGq2Z2Gfc
X-Proofpoint-ORIG-GUID: c7Vak2k3nd_Y44XXXJ-98GDHGq2Z2Gfc
X-Authority-Analysis: v=2.4 cv=WZuZ+EhX c=1 sm=1 tr=0 ts=6ab40395 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=7RKtW5IRJYTtfXkaynwA:9 a=CjuIK1q_8ugA:10
 a=IoOABgeZipijB_acs4fv:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA2NyBTYWx0ZWRfX1kc5awJOkNfw
 PRjLt9982AN7YeeCtHuxcEWZ+91voO46bLSBrH0LBhv7EU74EF9hbyb7CQMUOi5ciKcbBrn2mRn
 UZx3MUdPlFskoGxKMDe6sFhWXTyR6Ws=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA2NyBTYWx0ZWRfX3ma7gk+u9jhl
 IVY7Vs99BUfvBVP2AcrwfYX4cCDgKR8gnDKJEeedG+uoUEBz+3qVWrJ/ofj+JPU1hjmPxzFUslC
 IJhUgHlw1pqW5iWhcperieGP0QkQ5yPjJI89sm8pXzYP9RV5FwmP/tCLQCqNmisP65vHSUe6KdV
 tJiiwo25Bqbv3z+dWn4/aT8VZDn0rBmddWRqPf3co2R/BEY9QYX4ePO7sP1yPk2O4AulY8zBKnP
 RTimMtAd1uD7Cc5BlwvgwfXLsjrtlgtypHB90mTSF2pQyoxM2wGePxrHajqDtVViEd0ZRjR1WOf
 xjwFb4sPWFSzoy+fN663SsBuHHSS9EDE/0XNLthQSM9jVzFMhtKZLXI4si0TUlNh03ShPmqP8nl
 oRrtdeV9vB8R3z7Xrde35dNBUmyHIJJzoJybifSvLUV6g7KyvKZqyNV1Rn0Y1jGlTv3hNvBXxDx
 sSQAp8J+BZdbsgyeDSw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230067

On Tue, 22 Sep 2026 23:04:42 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> On 22/09/2026 20:25, Jonathan Cameron wrote:
> > On Sun, 20 Sep 2026 22:28:26 +0100
> > Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> > 
> > Hi Suzuki,
> >   
> >> Protected VMs doesn't allow setting offsets for virtual and phyiscal  
> > 
> > physical
> >   
> >> counters, as the offset is always fixed to 0. The VM ioclt is filtered  
> > 
> > ioctl
> >   
> >> out based on the cap. However we don't prevent the userspace from trying
> >> to write to the CNTVCT/CNTPCT registers. This would lead to KVM triggering
> >> a WARN() in timer_set_offset() as the vm_offset pointer is set to NULL.
> >>
> >> Fix this by always "fixing" the timer offsets to 0 and marking that the
> >> timer offset is set in the kvm->arch.flags at KVM init time for protected
> >> VMs. A userspace writing to the CNT*CT_EL0 would observe success, without
> >> any real effect. This was chosen over preventing the writes to these
> >> registers and returning -EPERM.  
> > 
> > Why?  I don't mind the decision but telling us what was chosen is something
> > we can see in the code - patch description should give us the stuff we
> > can't see.
> > 
> > One comment on the comment below.  
> >>
> >> Reported by Sashiko
> >>
> >> Link: https://lore.kernel.org/all/20260908164641.416911F00A3A@smtp.kernel.org
> >> Fixes: f7d05ee84a6a ("KVM: arm64: Prevent host from managing timer offsets for protected VMs")
> >> Suggested-by: Marc Zyngier <maz@kernel.org>
> >> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> >> ---
> >> Changes since v18:
> >>   - Retain NULL vm_offset for protected VMs to avoid host tampering with the
> >>     offset.
> >>   - Moved the flag setting into kvm_timer_init_vm(), where it should have been
> >>     in the first place
> >> ---
> >>   arch/arm64/kvm/arch_timer.c | 12 ++++++++++--
> >>   1 file changed, 10 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> >> index 6ac3321f4c575..226cd5a495c8b 100644
> >> --- a/arch/arm64/kvm/arch_timer.c
> >> +++ b/arch/arm64/kvm/arch_timer.c
> >> @@ -1110,8 +1110,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
> >>   		timer_context_init(vcpu, i);
> >>   
> >>   	/* Synchronize offsets across timers of a VM if not already provided */
> >> -	if (!vcpu_is_protected(vcpu) &&
> >> -	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
> >> +	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
> >>   		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
> >>   		timer_set_offset(vcpu_ptimer(vcpu), 0);
> >>   	}
> >> @@ -1133,6 +1132,15 @@ void kvm_timer_init_vm(struct kvm *kvm)
> >>   	 */
> >>   	for (int i = 0; i < NR_KVM_TIMERS; i++)
> >>   		kvm->arch.timer_data.ppi[i] = get_vgic_ppi(kvm, default_ppi[i]);
> >> +
> >> +	/*
> >> +	 * Protected VMs don't allow any offset being set from userspace,
> >> +	 * either set via writes to the counters or using the dedicated  
> > This sentence confused me.  Second clause isn't obviously the ways that
> > are being blocked. Maybe shorten to:
> > 
> > 	Protected VMs don't allow the offset to be set from userspace,
> > 	whether via writes to the counters or the dedicated ioctl.  
> 
> LLM suggests:
> 
> 
>     * Protected VMs don't allow userspace to set counter offsets,
>     * either via counter register writes or the dedicated ioctl.

Hmm.  I'd not combine a negative with either.  Still good enough I think!
Our Booker prize may be a way off yet :)

> 
> Have updated the comment.
> 
> Cheers
> Suzuki
> 
> >   
> >> +	 * ioctl. Pretend the offset has already been set and rely on the
> >> +	 * default offset being 0.
> >> +	 */
> >> +	if (kvm_vm_is_protected(kvm))
> >> +		set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
> >>   }
> >>   
> >>   void kvm_timer_cpu_up(void)  
> >   
> 

