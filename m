From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Filter out invalid core register IDs
 in KVM_GET_REG_LIST
Date: Fri, 14 Dec 2018 14:41:21 +0000
Message-ID: <20181214144119.GG3505@e103592.cambridge.arm.com>
References: <1544645824-16461-1-git-send-email-Dave.Martin@arm.com>
 <1544645824-16461-2-git-send-email-Dave.Martin@arm.com>
 <20181213183038.GC3505@e103592.cambridge.arm.com>
 <20181214142545.25rj2haxhhhzw4px@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181214142545.25rj2haxhhhzw4px@kamzik.brq.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 14, 2018 at 03:25:45PM +0100, Andrew Jones wrote:
> 
> Hi Dave,
> 
> The below looks like a nice kvm selftest. Care to fit it into that
> framework (tools/testing/selftests/kvm/) and post it?

Sure, it makes sense not to drop this on the floor.  Do you feel the
test needs to go in alongside the fix, or is it alright if I repost this
later on?

It will need a bit of cleanup, and I'm juggling other stuff too...

Cheers
---Dave

> 
> Thanks,
> drew
> 
> > [1]
> > 
> > #include <assert.h>
> > #include <errno.h>
> > #include <limits.h>
> > #include <stddef.h>
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <stdint.h>
> > #include <string.h>
> > #include <fcntl.h>
> > #include <sys/ioctl.h>
> > #include <linux/kvm.h>
> > 
> > #define KVM_PATH "/dev/kvm"
> > 
> > #define ARRAY_SIZE(array) (sizeof (array) / sizeof *(array))
> > 
> > static int get_reg_list(int vcpu, struct kvm_reg_list **pregs, size_t *psize)
> > {
> > 	struct kvm_reg_list *regs = *pregs;
> > 	size_t num_needed = 0;
> > 	const size_t reg_offset = (char *)&regs->reg - (char *)regs;
> > 
> > 	while (1) {
> > 		size_t size_needed = num_needed * sizeof regs->reg[0]
> > 					+ reg_offset;
> > 		if (size_needed > *psize) {
> > 			regs = realloc(regs, size_needed);
> > 			if (!regs)
> > 				goto nomem;
> > 
> > 			*pregs = regs;
> > 			*psize = size_needed;
> > 		}
> > 
> > 		regs->n = (*psize - reg_offset) / sizeof regs->reg[0];
> > 		if (!ioctl(vcpu, KVM_GET_REG_LIST, regs))
> > 			break;
> > 
> > 		if (errno != E2BIG) {
> > 			perror("KVM_GET_REG_LIST");
> > 			goto error;
> > 		}
> > 
> > 		num_needed = regs->n;
> > 	}
> > 
> > 	return 0;	
> > 
> > nomem:
> > 	errno = ENOMEM;
> > 	perror(NULL);
> > error:
> > 	return -1;
> > }
> > 
> > int main(void)
> > {
> > 	int fail = 0;
> > 	int kvm_fd, vm, vcpu;
> > 	struct kvm_vcpu_init init;
> > 	size_t i;
> > 	struct kvm_reg_list *regs = NULL;
> > 	size_t regs_size = 0;
> > 	uint64_t regdata[2];
> > 	struct kvm_one_reg reg;
> > 
> > 	kvm_fd = open(KVM_PATH, O_RDWR);
> > 	if (kvm_fd == -1) {
> > 		perror(KVM_PATH);
> > 		goto error;
> > 	}
> > 
> > 	vm = ioctl(kvm_fd, KVM_CREATE_VM, 0);
> > 	if (vm == -1) {
> > 		perror("KVM_CREATE_VM");
> > 		goto error;
> > 	}
> > 
> > 	if (ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init)) {
> > 		perror("KVM_ARM_PREFERRED_TARGET");
> > 		goto error;
> > 	}
> > 
> > 	printf("KVM_ARM_PREFERRED_TARGET:\n"
> > 	       "\ttarget = %lu\n",
> > 	       (unsigned long)init.target);
> > 	for (i = 0; i < ARRAY_SIZE(init.features); ++i)
> > 		printf("\tfeatures[0] = 0x%.8lx\n",
> > 		       (unsigned long)init.features[i]);
> > 	
> > 	vcpu = ioctl(vm, KVM_CREATE_VCPU, 0);
> > 	if (vcpu == -1) {
> > 		perror("KVM_CREATE_VCPU");
> > 		goto error;
> > 	}
> > 
> > 	if (!get_reg_list(vcpu, &regs, &regs_size)) {
> > 		fputs("Strange, KVM_GET_REG_LIST succeeded before KVM_VCPU_INIT!\n",
> > 		      stderr);
> > 			
> > 		goto error;
> > 	}
> > 
> > 	if (ioctl(vcpu, KVM_ARM_VCPU_INIT, &init)) {
> > 		perror("KVM_ARM_VCPU_INIT");
> > 		goto error;
> > 	}
> > 
> > 	if (get_reg_list(vcpu, &regs, &regs_size))
> > 		goto error;
> > 
> > 	assert(1 <= -1ULL >> 32);
> > 	assert(ULONG_MAX >= (1ULL << 32) - 1);
> > 	for (i = 0; i < regs->n; ++i) {
> > 		size_t size;
> > 		char const *s1 = "OK", *s2 = "", *s3 = "";;
> > 
> > 		size = (size_t)1 << ((regs->reg[i] & KVM_REG_SIZE_MASK) >>
> > 				     KVM_REG_SIZE_SHIFT);
> > 		if (size < 4 || size > 16) {
> > 			s1 = "BADSIZE";
> > 			fail = 1;
> > 		} else {
> > 			memset(&reg, 0, sizeof reg);
> > 
> > 			reg.id = regs->reg[i];
> > 			reg.addr = (__u64)&regdata;
> > 			if (ioctl(vcpu, KVM_GET_ONE_REG, &reg)) {
> > 				s1 = "FAIL (";
> > 				s2 = strerror(errno);
> > 				s3 = ")";
> > 				fail = 1;
> > 			}
> > 		}
> > 
> > 		printf("\t0x%.16lx\t%s%s%s\n",
> > 		       (unsigned long)reg.id, s1, s2, s3);
> > 	
> > 	}
> > 
> > 	if (ferror(stdout) || fflush(stdout))
> > 		goto stdout_error;
> > 	
> > 	if (fail) {
> > 		puts("FAIL");
> > 		goto error;
> > 	}
> > 
> > 	if (puts("\nPASS") == EOF || fclose(stdout))
> > 		goto stdout_error;
> > 
> > 	return EXIT_SUCCESS;
> > 
> > stdout_error:
> > 	fputs("I/O error", stderr);
> > error:
> > 	return EXIT_FAILURE;
> > }
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
