From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH V3 4/5] kvm/stats: Add provisioning for 64-bit vm and vcpu
 statistics
Date: Wed, 13 Jul 2016 11:04:08 +0200
Message-ID: <57860408.1000203@de.ibm.com>
References: <1468400015-4834-1-git-send-email-sjitindarsingh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45199499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 04:58:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y8nzX78jTax2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2016 04:58:35 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAC1D4998D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 04:58:35 -0400 (EDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id
 u6D93cpn104838
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 05:04:26 -0400
Received: from e06smtp09.uk.ibm.com (e06smtp09.uk.ibm.com [195.75.94.105])
 by mx0a-001b2d01.pphosted.com with ESMTP id 24507bubed-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 05:04:24 -0400
Received: from localhost
 by e06smtp09.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <borntraeger@de.ibm.com>;
 Wed, 13 Jul 2016 10:04:22 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id B478417D8062
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 10:05:38 +0100 (BST)
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com
 [9.149.37.248])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 u6D94Cld62193780
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 09:04:12 GMT
Received: from d06av07.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av07.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 u6D94Auw012952
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 05:04:11 -0400
In-Reply-To: <1468400015-4834-1-git-send-email-sjitindarsingh@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suraj Jitindar Singh <sjitindarsingh@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: linux-mips@linux-mips.org, linux-s390@vger.kernel.org, james.hogan@imgtec.com, kvm@vger.kernel.org, marc.zyngier@arm.com, benh@kernel.crashing.org, kvm-ppc@vger.kernel.org, paulus@samba.org, mpe@ellerman.id.au, cornelia.huck@de.ibm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, agraf@suse.com
List-Id: kvmarm@lists.cs.columbia.edu

On 07/13/2016 10:53 AM, Suraj Jitindar Singh wrote:
> vms and vcpus have statistics associated with them which can be viewed
> within the debugfs. Currently it is assumed within the vcpu_stat_get() and
> vm_stat_get() functions that all of these statistics are represented as
> u32s, however the next patch adds some u64 statistics.
> 
> Thus modify these two functions, vcpu_stat_get() and vm_stat_get(), such
> that they expect u64 statistics and update vm and vcpu statistics to u64s
> accordingly.
> 
> ---
> Change Log:
> 
> V1 -> V2:
> 	- Nothing
> V2 -> V3:
> 	- Instead of implementing separate u32 and u64 functions keep the
> 	  generic functions and modify them to expect u64s. Thus update all
> 	  vm and vcpu statistics to u64s accordingly.

Have not looked into everything, but I agree with changing everything to 64bit.


> @@ -3583,8 +3583,8 @@ static const struct file_operations vcpu_stat_get_per_vm_fops = {
>  };
> 
>  static const struct file_operations *stat_fops_per_vm[] = {
> -	[KVM_STAT_VCPU] = &vcpu_stat_get_per_vm_fops,
> -	[KVM_STAT_VM]   = &vm_stat_get_per_vm_fops,
> +	[KVM_STAT_VCPU]		= &vcpu_stat_get_per_vm_fops,
> +	[KVM_STAT_VM]		= &vm_stat_get_per_vm_fops,
>  };
unrelated white space changes?

> 
>  static int vm_stat_get(void *_offset, u64 *val)
> @@ -3628,8 +3628,8 @@ static int vcpu_stat_get(void *_offset, u64 *val)
>  DEFINE_SIMPLE_ATTRIBUTE(vcpu_stat_fops, vcpu_stat_get, NULL, "%llu\n");
> 
>  static const struct file_operations *stat_fops[] = {
> -	[KVM_STAT_VCPU] = &vcpu_stat_fops,
> -	[KVM_STAT_VM]   = &vm_stat_fops,
> +	[KVM_STAT_VCPU]		= &vcpu_stat_fops,
> +	[KVM_STAT_VM]		= &vm_stat_fops,
>  };
> 
>  static int kvm_init_debug(void)
> 
