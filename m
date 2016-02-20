From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v11 20/21] KVM: ARM: Introduce per-vcpu kvm device controls
Date: Sat, 20 Feb 2016 21:38:16 +0800
Message-ID: <56C86C48.2060702@linaro.org>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com> <1454656456-11640-21-git-send-email-zhaoshenglong@huawei.com> <20160208124059.GF620@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160208124059.GF620@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/8 20:40, Christoffer Dall wrote:
>> +	case KVM_SET_DEVICE_ATTR: {
>> >+		if (copy_from_user(&attr, argp, sizeof(attr)))
>> >+			return -EFAULT;
>> >+		return kvm_arm_vcpu_set_attr(vcpu, &attr);
>> >+	}
>> >+	case KVM_GET_DEVICE_ATTR: {
>> >+		if (copy_from_user(&attr, argp, sizeof(attr)))
>> >+			return -EFAULT;
>> >+		return kvm_arm_vcpu_get_attr(vcpu, &attr);
>> >+	}
>> >+	case KVM_HAS_DEVICE_ATTR: {
>> >+		if (copy_from_user(&attr, argp, sizeof(attr)))
>> >+			return -EFAULT;
>> >+		return kvm_arm_vcpu_has_attr(vcpu, &attr);
>> >+	}
> do we share the ioctl number space across device, VM, and VCPU file
> descriptors?
Yeah, they're shared across device, VM, and VCPU.

Thanks,
-- 
Shannon
