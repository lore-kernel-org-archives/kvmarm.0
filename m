From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v11 0/4] set VSESR_EL2 by user space and support
 NOTIFY_SEI notification
Date: Thu, 19 Apr 2018 12:09:30 +0800
Message-ID: <ebfea154-eceb-b2d2-d038-f27687d2bc01@huawei.com>
References: <1523309796-36423-1-git-send-email-gengdongjiu@huawei.com>
 <d94439b6-9b9a-9bd0-ddec-3bb63ede9461@arm.com>
 <5161fb31-e5bb-872c-3e12-d7d38326aaca@huawei.com>
 <eb65baf4-abb0-570f-f3af-61f505c9de10@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eb65baf4-abb0-570f-f3af-61f505c9de10@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, zhengxiang9@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

James,

> 
>> I do not know when it is merge-window. About the apply version, it does not have limited.
> 
> 'git fetch' Linus' tree and look at the tags. 'v4.16' lost its '-rc' suffixes,
> and there isn't a 'v4.17-rc1' yet, so we are still in the merge window.
> 
> Linus sends a message to LKML. eg:
> https://lkml.org/lkml/2018/4/1/175
> 
> net-next closes shortly before the merge window, and re-opens afterwards. There
> is a handy web page:
> http://vger.kernel.org/~davem/net-next.html

 Thanks for this information, got it.
