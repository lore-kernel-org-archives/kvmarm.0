Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36305C43219
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 01:56:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD8E54B8DE;
	Tue, 15 Nov 2022 20:56:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i8201JaUED91; Tue, 15 Nov 2022 20:56:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB4F34B8BA;
	Tue, 15 Nov 2022 20:56:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3278A4B86B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 20:56:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id scqiNk2TnEVN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 20:56:18 -0500 (EST)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DBC64B84E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 20:56:17 -0500 (EST)
Received: by mail-pl1-f169.google.com with SMTP id io19so15083906plb.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 17:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=KVMI/nFFiiWGPsODZP4uTO9+eDXKExXBhUQy4MPYB78=;
 b=ZkhmtpyvuQjtpiKcSTwV4FQaNI1BndPmVfYwRbI4kyGyIBWLGYAK9adsViZh/yHJ7x
 GuxgtogV7PtxaPytplYxo+Klt0B/2ry2vtbUojn3VI5CZqcW98TXvlxs8G1FSU2NCLPG
 osV9xc1d2y7cg0+wNaz5Nf0N26qzO6pIP5sDWfotE89nSnvse7sYp7t8PQ00S927CjrN
 Mt9iItQr7ceVWaHS8qhCiI1BYymChnkKt5hyJqGOY0FEweE8dtCPm+eSBErPLu7yhTm8
 o9dFADTr9ZdWsubEfckpwD5DI+8OZmAD6JfaYPF77XPfSWF6ATOhEkaqdt7s4F4xOEiQ
 xj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=KVMI/nFFiiWGPsODZP4uTO9+eDXKExXBhUQy4MPYB78=;
 b=o5QS7/zT28xkIfLvCTglW3SUfNwXXWdbwT65AF+bu+/8ySapWqPucBTpT6VpBDKLZa
 i+oVsTCNA+Kj96otgjuF+ib+OwR0iItOLK4NTep0vTABtStmfI0AmSpiLvIUDbRsTT39
 VGamnr+wl0lXcEMUxKQ+Bs8NL6b92tMn8Z02YzAbyp/7aEbc/OI0wOsQO2ntOWTU33dy
 Gm1a21zfrTf3OI1KkQEgsIFcsvISAYT7996FUF1KuZPnjdRElOHc3yCoPdkcogZn6ZDG
 +8I1lwvtiv7AZERzy9pQsTuF56epshrUPg8Gmf9ZkUeBwWCpFV79nvqtWfPDBUe1ijcQ
 Mhng==
X-Gm-Message-State: ANoB5pmbt/+g0VcHRfzcpQGSgBjtL1P7lDgpTEOcfxAXk8fc4lsbhmXf
 wBayWBMREJfft7MHxSPCGzS0Ig==
X-Google-Smtp-Source: AA0mqf6H0QJ9u7lmf5OzgdM3vacJIFtJ+zbl369j6MJCYNSFKT6kmzTaZY88ji+zMgthkUAHrSJWdg==
X-Received: by 2002:a17:90a:5883:b0:218:f84:3f98 with SMTP id
 j3-20020a17090a588300b002180f843f98mr1206419pji.238.1668563776878; 
 Tue, 15 Nov 2022 17:56:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 z25-20020aa79499000000b0056ca3569a66sm9483483pfk.129.2022.11.15.17.56.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Nov 2022 17:56:16 -0800 (PST)
Date: Wed, 16 Nov 2022 01:56:12 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
Message-ID: <Y3RDPOerOIf6SwI0@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-34-seanjc@google.com>
 <95c3cce88560024566f3b4b0061ca7e62a8a4286.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <95c3cce88560024566f3b4b0061ca7e62a8a4286.camel@intel.com>
Cc: "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "david@redhat.com" <david@redhat.com>, "Yao, Yuan" <yuan.yao@intel.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "Gao,
 Chao" <chao.gao@intel.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "atishp@atishpatra.org" <atishp@atishpatra.org>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Nov 15, 2022, Huang, Kai wrote:
> On Wed, 2022-11-02 at 23:19 +0000, Sean Christopherson wrote:
> > +static bool __init kvm_is_vmx_supported(void)
> > +{
> > +	if (!cpu_has_vmx()) {
> > +		pr_err("CPU doesn't support VMX\n");
> > +		return false;
> > +	}
> > +
> > +	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
> > +	=A0=A0=A0 !boot_cpu_has(X86_FEATURE_VMX)) {
> > +		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL\n");
> > +		return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > =A0static int __init vmx_check_processor_compat(void)
> > =A0{
> > =A0	struct vmcs_config vmcs_conf;
> > =A0	struct vmx_capability vmx_cap;
> > =A0
> > -	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
> > -	=A0=A0=A0 !this_cpu_has(X86_FEATURE_VMX)) {
> > -		pr_err("VMX is disabled on CPU %d\n", smp_processor_id());
> > +	if (!kvm_is_vmx_supported())
> > =A0		return -EIO;
> > -	}
> > =A0
> =

> Looks there's a functional change here -- the old code checks local cpu's
> feature bits but the new code always checks bsp's feature bits.  Should h=
ave no
> problem I think, though.

Ouch.  The bad check will defeat the purpose of doing compat checks.  Nice =
catch!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
