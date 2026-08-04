Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3307C43BDAC;
	Tue,  4 Aug 2026 08:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833834; cv=none; b=i9Xq/2Wj0sXCXMRb46DbE7494Sr5Is+fSczGagxSJx9a1bgc33KZm4GdB/QOS6RLhMUkx41EIOd6I8zn4RENBCMDvL1o41Is6zJaIWG/Ek7V4cwgrakyEUJRJl/+xLbT0vPmrH6OtZwk8WruXhW0GHpxc4QzpVP+QIWyOzEWFcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833834; c=relaxed/simple;
	bh=EWmgbJlVXftcAZw8ONc8X9BQ1H09O3p9MgB5FgvLadc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jiipUW5ugDI008w0jlvAziF/EPyAC9ueH0HE/1ciom9OVgGQM/fL8xSSl1wF9SkA83JDhfLdEgr1K0McQ8cZ0jvWJ+z2vu2YpAWgAfMArbc+37+GZMKlcPCDfM2wg56rvnFbOlrgRPPnwljb19KLWpdI6zni2Vr6dDnGldehUHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UT90DsPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UT90DsPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E3A1F000E9;
	Tue,  4 Aug 2026 08:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785833832;
	bh=xxS0NRBY3i0kZcuHxe0V5BgtVYZZ3/0KR07GPgwzac4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UT90DsPzrSuia1XzFFet3nOueTooswWOFwwvIVVUp4i31U91QcZdNkPS7wDN44WfZ
	 5SW8BtiDJsI6Fx9pak/IUmX5Z2J+CsBdP8wwjY3f2mQUM4eQIABFyJaXxGJhayR1gn
	 U5R+0MEmOP50TZcTUR7p1eCgQVGCvP9a8smRHHuChY1zUBlFlrNOJSODIP4Z9/TPfi
	 uBn3/pDxKsMyP6756Kk1ACB4f53ti49Pq6U7ezDbTVRR4O1TOTd6/BFPY6zByPR6tj
	 IFWmH0hMFRtARMPxU/r8zriH6wy2JEQQcyViZK2NO2uukW7vthHJI/O6clzH5elLoU
	 7Nyp9EMGnWMEA==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 21/45] KVM: arm64: CCA: Handle realm enter/exit
In-Reply-To: <20260803134403.80630-22-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-22-steven.price@arm.com>
Date: Tue, 04 Aug 2026 14:27:03 +0530
Message-ID: <yq5a5x1q461s.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_SYNC:
> +		/*
> +		 * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
> +		 * see __get_fault_info()
> +		 */
> +		vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar | HPFAR_EL2_NS;
> +		rec_exit_sync(vcpu);
> +		return ARM_EXCEPTION_TRAP;
> +	case RMI_EXIT_IRQ:
> +	case RMI_EXIT_FIQ:
> +		return ARM_EXCEPTION_IRQ;
> +	case RMI_EXIT_SERROR:
> +		return ARM_EXCEPTION_EL1_SERROR;
> +	case RMI_EXIT_PSCI:
> +		rec_exit_hvc(vcpu);
> +		kvm_make_request(KVM_REQ_RMI, vcpu);
> +		return ARM_EXCEPTION_TRAP;
> +	case RMI_EXIT_RIPAS_CHANGE:
> +		rec_exit_hvc(vcpu);
> +		return ARM_EXCEPTION_TRAP;
> +	}

Should we handle RMI_EXIT_RIPAS_CHANGE differently? Currently, the call path is:

kvm_rec_exit()
-> RMI_EXIT_RIPAS_CHANGE
-> handle_hvc()
-> kvm_rec_handle_hvc()
-> kvm_prepare_memory_fault_exit()

Could we instead treat RMI_EXIT_RIPAS_CHANGE as a special case and avoid
redirecting it through handle_hvc()? The completion part of the RIPAS
change could still be handled by kvm_rec_handle_request().


-bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret)
+static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
 {
-	struct realm_rec *rec;
+	struct realm_rec *rec = &vcpu->arch.rec;
 	struct realm *realm;
 	unsigned long base;
 	unsigned long ripas;
 	unsigned long top;
 
-	if (!vcpu_is_rec(vcpu))
-		return false;
-
-	rec = &vcpu->arch.rec;
-	if (rec->run->exit.exit_reason != RMI_EXIT_RIPAS_CHANGE)
-		return false;
-
 	realm = &vcpu->kvm->arch.realm;
 	base = rec->run->exit.ripas_base;
 	top = rec->run->exit.ripas_top;
@@ -89,8 +83,7 @@ bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret)
 			 base, top, ripas);
 		/* Set RMI_REJECT bit */
 		rec->run->enter.flags = REC_ENTER_FLAG_RIPAS_RESPONSE;
-		*ret = -EINVAL;
-		return true;
+		return -EINVAL;
 	}
 
 	/* Exit to VMM, the actual RIPAS change is done on next entry */
@@ -102,8 +95,7 @@ bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret)
 	 * KVM_EXIT_MEMORY_FAULT requires a return code of -EFAULT, see the
 	 * API documentation
 	 */
-	*ret = -EFAULT;
-	return true;
+	return -EFAULT;
 }
 
 int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
@@ -169,8 +161,7 @@ int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 		kvm_make_request(KVM_REQ_RMI, vcpu);
 		return ARM_EXCEPTION_TRAP;
 	case RMI_EXIT_RIPAS_CHANGE:
-		rec_exit_hvc(vcpu);
-		return ARM_EXCEPTION_TRAP;
+		return rec_exit_ripas_change(vcpu);
 	}
 
 	return rec_exit_fatal(vcpu, "Unsupported Realm exit reason",

-aneesh
