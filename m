From: "Kalra, Ashish" <Ashish.Kalra@cavium.com>
Subject: Re: kvm-unit-tests arm ptimer test
Date: Thu, 10 Aug 2017 12:33:08 +0530
Message-ID: <417ba96f-8ec0-f366-1105-a9cdd3bcb2d8@cavium.com>
References: <b1a2b7f6-565b-0702-b038-02e7400d30c7@cavium.com>
 <7676eb49-144d-9592-e320-cd31793d1913@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B6949C2F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 03:01:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GjeqltoXn3B5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Aug 2017 03:01:58 -0400 (EDT)
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0082.outbound.protection.outlook.com [104.47.32.82])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93D5540A86
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Aug 2017 03:01:58 -0400 (EDT)
In-Reply-To: <7676eb49-144d-9592-e320-cd31793d1913@cavium.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Just realized that KVM/ARM now supports EL1 physical timer emulation
for guests and had a look at the patch set that enables VMs to use the 
EL1 physical timer through trap-and-emulate for arm64. I am using an
older KVM release which is causing guest termination on physical
timer access.

Thanks,
Ashish

On 8/10/2017 3:01 AM, Kalra, Ashish wrote:
> Hello,
> 
> I have a general question on the ptimer test for KVM unit tests for the 
> ARM/ARM64 platform, as the guest is only allowed to access to the 
> physical counter and access to the physical timer is not allowed for the 
> guest (CNTHCTL.EL1PCTEN is set and CNTHCTL.EL1PCEN is clear), so how is 
> this ptimer test supposed to pass :
> 
> For example, in this test, reading CNTP_{CTL/CVAL}_EL0 will always cause 
> exceptions while running in guest in the following function :
> 
> static void print_ptimer_info(void)
> {
>      printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
>      printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
>      printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
> }
> 
> Thanks,
> Ashish
